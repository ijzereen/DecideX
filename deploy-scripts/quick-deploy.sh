#!/bin/bash

# AWS 빠른 배포 스크립트
# 사용법: ./quick-deploy.sh

set -e

echo "🚀 AWS 빠른 배포 시작..."

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 함수 정의
print_step() {
    echo -e "${BLUE}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 사전 확인
print_step "사전 확인 중..."

# AWS CLI 확인
if ! command -v aws &> /dev/null; then
    print_error "AWS CLI가 설치되지 않았습니다."
    echo "설치 방법: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    exit 1
fi

# AWS 자격 증명 확인
if ! aws sts get-caller-identity &> /dev/null; then
    print_error "AWS 자격 증명이 설정되지 않았습니다."
    echo "설정 방법: aws configure"
    exit 1
fi

print_success "AWS CLI 및 자격 증명 확인 완료"

# Git 상태 확인
if [ -n "$(git status --porcelain)" ]; then
    print_warning "커밋되지 않은 변경사항이 있습니다."
    read -p "계속하시겠습니까? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 1. 백엔드 배포 (App Runner)
print_step "1. 백엔드 배포 준비 중..."

# App Runner 서비스 이름
APP_RUNNER_SERVICE_NAME="mindmap-backend"

echo "App Runner 서비스 생성/업데이트를 위해 AWS 콘솔을 사용해주세요:"
echo "1. AWS 콘솔 → App Runner → Create service"
echo "2. GitHub 연결 및 리포지토리 선택"
echo "3. Configuration file: backend/apprunner.yaml"
echo "4. 환경변수 설정:"
echo "   - CLAUDE_API_KEY: [실제 키 입력]"
echo "   - GEMINI_API_KEY: [실제 키 입력]"
echo ""

read -p "App Runner 배포가 완료되면 Enter를 눌러주세요..."

# App Runner URL 입력 받기
read -p "App Runner URL을 입력해주세요 (예: https://xxx.region.awsapprunner.com): " APP_RUNNER_URL

if [ -z "$APP_RUNNER_URL" ]; then
    print_error "App Runner URL이 필요합니다."
    exit 1
fi

print_success "백엔드 URL: $APP_RUNNER_URL"

# 2. 프론트엔드 배포 (Amplify)
print_step "2. 프론트엔드 배포 준비 중..."

echo "Amplify 앱 생성/업데이트를 위해 AWS 콘솔을 사용해주세요:"
echo "1. AWS 콘솔 → Amplify → Create new app"
echo "2. GitHub 연결 및 리포지토리 선택"
echo "3. Root directory: mindmap-app"
echo "4. 환경변수 설정:"
echo "   - REACT_APP_API_URL: $APP_RUNNER_URL"
echo ""

read -p "Amplify 배포가 완료되면 Enter를 눌러주세요..."

# Amplify URL 입력 받기
read -p "Amplify URL을 입력해주세요 (예: https://xxx.amplifyapp.com): " AMPLIFY_URL

if [ -z "$AMPLIFY_URL" ]; then
    print_error "Amplify URL이 필요합니다."
    exit 1
fi

print_success "프론트엔드 URL: $AMPLIFY_URL"

# 3. 도메인 설정 (선택사항)
print_step "3. 도메인 설정 (선택사항)"

read -p "커스텀 도메인을 설정하시겠습니까? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "도메인명을 입력해주세요 (예: mydomain.com): " DOMAIN_NAME
    
    if [ -n "$DOMAIN_NAME" ]; then
        echo "도메인 설정 단계:"
        echo "1. Route 53에서 도메인 구매 또는 기존 도메인 사용"
        echo "2. Amplify에서 도메인 연결: $DOMAIN_NAME"
        echo "3. Route 53에서 API 서브도메인 설정: api.$DOMAIN_NAME → $APP_RUNNER_URL"
        echo ""
        
        # CORS 업데이트 안내
        print_warning "백엔드 CORS 설정 업데이트가 필요합니다:"
        echo "backend/main.py에서 allow_origins에 다음 추가:"
        echo "  - \"https://$DOMAIN_NAME\""
        echo "  - \"https://www.$DOMAIN_NAME\""
        echo ""
        
        read -p "도메인 설정이 완료되면 Enter를 눌러주세요..."
    fi
fi

# 4. 최종 테스트
print_step "4. 최종 테스트"

echo "배포 완료! 다음 URL들을 테스트해주세요:"
echo ""
echo "🔗 백엔드 API: $APP_RUNNER_URL/health"
echo "🔗 프론트엔드: $AMPLIFY_URL"

if [ -n "$DOMAIN_NAME" ]; then
    echo "🔗 커스텀 도메인: https://$DOMAIN_NAME"
    echo "🔗 API 도메인: https://api.$DOMAIN_NAME/health"
fi

echo ""
print_success "배포가 완료되었습니다! 🎉"

# 배포 정보 저장
cat > deployment-info.txt << EOF
# 배포 정보
배포 날짜: $(date)
백엔드 URL: $APP_RUNNER_URL
프론트엔드 URL: $AMPLIFY_URL
EOF

if [ -n "$DOMAIN_NAME" ]; then
    echo "커스텀 도메인: https://$DOMAIN_NAME" >> deployment-info.txt
fi

print_success "배포 정보가 deployment-info.txt에 저장되었습니다."

echo ""
echo "📚 추가 리소스:"
echo "- AWS 배포 가이드: AWS_DEPLOYMENT_GUIDE.md"
echo "- 모니터링: CloudWatch 로그 확인"
echo "- 비용 관리: AWS Cost Explorer"
