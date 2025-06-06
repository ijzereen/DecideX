# Elastic Beanstalk 배포 체크리스트

## 배포 전 준비사항 ✅

### 1. 환경 설정
- [ ] AWS CLI 설치 및 설정 완료
- [ ] EB CLI 설치 완료
- [ ] AWS 자격 증명 설정 (`aws configure`)
- [ ] `.env` 파일 생성 및 API 키 설정

### 2. 코드 준비
- [ ] `main.py` - FastAPI 애플리케이션 코드 확인
- [ ] `application.py` - EB WSGI 엔트리포인트 생성
- [ ] `requirements.txt` - 모든 의존성 포함 확인
- [ ] `Procfile` - 프로세스 정의 확인

### 3. EB 설정 파일
- [ ] `.ebextensions/01_python.config` - Python 환경 설정
- [ ] `.ebextensions/02_environment.config` - 환경 변수 설정
- [ ] `.ebextensions/03_nginx.config` - Nginx 프록시 설정
- [ ] `.platform/nginx/conf.d/proxy.conf` - 최신 플랫폼 Nginx 설정
- [ ] `.platform/hooks/postdeploy/01_migrate.sh` - 배포 후 스크립트
- [ ] `.ebignore` - 업로드 제외 파일 설정

## 배포 실행 ✅

### 자동 배포 (권장)
```bash
cd backend
./deploy-eb.sh story-generator-api-prod
```

### 수동 배포
```bash
cd backend
eb init story-generator-api --region ap-northeast-2 --platform "Python 3.11"
eb create story-generator-api-prod --instance-type t3.micro
eb setenv CLAUDE_API_KEY=your_key GEMINI_API_KEY=your_key DEBUG=False
eb deploy story-generator-api-prod
```

## 배포 후 확인사항 ✅

### 1. 기본 상태 확인
- [ ] `eb status` - 환경 상태가 "Ready"인지 확인
- [ ] `eb health` - 애플리케이션 헬스 상태 확인
- [ ] `eb logs --all` - 에러 로그 확인

### 2. 엔드포인트 테스트
- [ ] `GET /` - 루트 엔드포인트 응답 확인
- [ ] `GET /health` - 헬스 체크 엔드포인트 확인
- [ ] `GET /docs` - FastAPI 문서 페이지 접근 확인
- [ ] `POST /api/generate-story` - 주요 API 기능 테스트

### 3. 환경 변수 확인
- [ ] `eb printenv` - 환경 변수 올바르게 설정되었는지 확인
- [ ] API 키들이 올바르게 설정되었는지 확인
- [ ] CORS 설정이 프론트엔드 도메인과 일치하는지 확인

## 성능 및 보안 최적화 ✅

### 1. 인스턴스 설정
- [ ] 적절한 인스턴스 타입 선택 (t3.micro → t3.small)
- [ ] Auto Scaling 설정 (최소 1, 최대 4)
- [ ] Load Balancer 헬스 체크 설정

### 2. 보안 설정
- [ ] HTTPS 설정 (SSL 인증서)
- [ ] Security Group 규칙 최소화
- [ ] 환경 변수 보안 (Parameter Store 사용 고려)

### 3. 모니터링 설정
- [ ] CloudWatch 로그 활성화
- [ ] Enhanced Health Reporting 활성화
- [ ] 알람 설정 (CPU, 메모리, 응답 시간)

## 문제 해결 체크리스트 🔧

### 배포 실패시
- [ ] `eb logs --all` 로그 확인
- [ ] `requirements.txt` 의존성 확인
- [ ] `application.py` 파일 경로 및 내용 확인
- [ ] 환경 변수 설정 확인

### 애플리케이션 시작 실패시
- [ ] Python 버전 호환성 확인
- [ ] 포트 설정 확인 (8000)
- [ ] WSGI 애플리케이션 객체 확인

### Nginx 프록시 오류시
- [ ] `.platform/nginx/conf.d/proxy.conf` 설정 확인
- [ ] 업스트림 서버 주소 확인 (127.0.0.1:8000)
- [ ] 프록시 헤더 설정 확인

## 배포 완료 후 작업 ✅

### 1. 문서 업데이트
- [ ] API 엔드포인트 URL 업데이트
- [ ] 프론트엔드 CORS 설정 업데이트
- [ ] 환경별 설정 문서화

### 2. 팀 공유
- [ ] 배포 URL 팀에 공유
- [ ] API 문서 링크 공유
- [ ] 환경 변수 설정 방법 공유

### 3. 모니터링 설정
- [ ] CloudWatch 대시보드 생성
- [ ] 알람 설정 및 알림 채널 구성
- [ ] 로그 모니터링 설정

## 주요 명령어 참고 📝

```bash
# 상태 확인
eb status [environment-name]
eb health [environment-name]

# 로그 확인
eb logs [environment-name] --all

# 환경 변수 관리
eb printenv [environment-name]
eb setenv KEY=VALUE [environment-name]

# 스케일링
eb scale [number] [environment-name]

# 설정 변경
eb config [environment-name]

# 환경 종료
eb terminate [environment-name]
```

## 비상 연락처 및 리소스 📞

- AWS Support: [AWS 지원 센터](https://console.aws.amazon.com/support/)
- EB 문서: [Elastic Beanstalk 개발자 가이드](https://docs.aws.amazon.com/elasticbeanstalk/)
- FastAPI 문서: [FastAPI 공식 문서](https://fastapi.tiangolo.com/)

---

**배포 완료 날짜:** ___________  
**배포자:** ___________  
**환경 URL:** ___________  
**특이사항:** ___________
