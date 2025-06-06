#!/bin/bash

# Elastic Beanstalk 배포 스크립트
# 사용법: ./deploy-eb.sh [environment-name]

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 로그 함수들
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 환경 변수 설정
ENVIRONMENT_NAME=${1:-"story-generator-api-prod"}
APPLICATION_NAME="story-generator-api"
REGION="ap-northeast-2"

log_info "Elastic Beanstalk 배포 시작..."
log_info "애플리케이션: $APPLICATION_NAME"
log_info "환경: $ENVIRONMENT_NAME"
log_info "리전: $REGION"

# 필수 도구 확인
if ! command -v eb &> /dev/null; then
    log_error "EB CLI가 설치되지 않았습니다."
    log_info "설치 방법: pip install awsebcli"
    exit 1
fi

if ! command -v aws &> /dev/null; then
    log_error "AWS CLI가 설치되지 않았습니다."
    log_info "설치 방법: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    exit 1
fi

# AWS 자격 증명 확인
if ! aws sts get-caller-identity &> /dev/null; then
    log_error "AWS 자격 증명이 설정되지 않았습니다."
    log_info "설정 방법: aws configure"
    exit 1
fi

# 현재 디렉토리가 backend인지 확인
if [[ ! -f "main.py" || ! -f "requirements.txt" ]]; then
    log_error "backend 디렉토리에서 실행해주세요."
    exit 1
fi

# .env 파일 확인
if [[ ! -f ".env" ]]; then
    log_warning ".env 파일이 없습니다. .env.example을 참고하여 생성해주세요."
    read -p "계속하시겠습니까? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# EB 초기화 (이미 초기화된 경우 스킵)
if [[ ! -f ".elasticbeanstalk/config.yml" ]]; then
    log_info "Elastic Beanstalk 초기화 중..."
    eb init $APPLICATION_NAME --region $REGION --platform "Python 3.11"
else
    log_info "Elastic Beanstalk이 이미 초기화되어 있습니다."
fi

# 환경 상태 확인
log_info "환경 상태 확인 중..."
if eb status $ENVIRONMENT_NAME &> /dev/null; then
    log_info "환경 '$ENVIRONMENT_NAME'이 존재합니다."
    
    # 환경 상태 확인
    STATUS=$(eb status $ENVIRONMENT_NAME | grep "Status:" | awk '{print $2}')
    log_info "현재 상태: $STATUS"
    
    if [[ "$STATUS" != "Ready" ]]; then
        log_warning "환경이 Ready 상태가 아닙니다. 배포를 계속하시겠습니까?"
        read -p "계속하시겠습니까? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
else
    log_info "환경 '$ENVIRONMENT_NAME'을 생성합니다..."
    eb create $ENVIRONMENT_NAME --instance-type t3.micro --region $REGION
fi

# 환경 변수 설정 (선택사항)
log_info "환경 변수 설정을 확인합니다..."
if [[ -f ".env" ]]; then
    log_info ".env 파일에서 환경 변수를 읽어옵니다..."
    
    # .env 파일의 각 라인을 읽어서 환경 변수로 설정
    while IFS='=' read -r key value; do
        # 주석과 빈 줄 건너뛰기
        if [[ $key =~ ^#.*$ ]] || [[ -z $key ]]; then
            continue
        fi
        
        # 따옴표 제거
        value=$(echo $value | sed 's/^["'\'']//' | sed 's/["'\'']$//')
        
        log_info "환경 변수 설정: $key"
        eb setenv $key="$value" --environment $ENVIRONMENT_NAME
    done < .env
fi

# 배포 실행
log_info "애플리케이션 배포 중..."
eb deploy $ENVIRONMENT_NAME --timeout 20

# 배포 결과 확인
if [[ $? -eq 0 ]]; then
    log_success "배포가 성공적으로 완료되었습니다!"
    
    # 애플리케이션 URL 가져오기
    URL=$(eb status $ENVIRONMENT_NAME | grep "CNAME:" | awk '{print $2}')
    if [[ -n "$URL" ]]; then
        log_success "애플리케이션 URL: http://$URL"
        log_info "Health Check: http://$URL/health"
        log_info "API 문서: http://$URL/docs"
    fi
    
    # 로그 확인 옵션
    read -p "최근 로그를 확인하시겠습니까? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        eb logs $ENVIRONMENT_NAME --all
    fi
else
    log_error "배포에 실패했습니다."
    log_info "로그를 확인해보세요: eb logs $ENVIRONMENT_NAME"
    exit 1
fi

log_success "배포 스크립트 완료!"
