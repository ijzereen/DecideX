# AWS 배포 가이드

이 가이드는 FastAPI 백엔드와 React 프론트엔드를 AWS에 배포하는 단계별 과정을 설명합니다.

## 사전 준비사항

1. AWS 계정 생성 및 로그인
2. AWS CLI 설치 및 구성 (선택사항)
3. GitHub 계정 및 리포지토리 준비
4. API 키 준비 (Claude, Gemini)

## 1. 백엔드 배포 (App Runner) - 10분

### 1.1 GitHub 리포지토리 준비
1. 현재 프로젝트를 GitHub에 푸시
2. `backend/` 폴더에 `apprunner.yaml` 파일이 있는지 확인

### 1.2 App Runner 서비스 생성
1. AWS 콘솔에서 App Runner 서비스로 이동
2. "Create service" 클릭
3. **Source and deployment** 설정:
   - Repository type: GitHub
   - Connect to GitHub 클릭하여 연결
   - Repository: 프로젝트 리포지토리 선택
   - Branch: main (또는 배포할 브랜치)
   - Deployment trigger: Automatic
   - Configuration file: Use configuration file
   - Configuration file location: `backend/apprunner.yaml`

4. **Service settings** 설정:
   - Service name: `mindmap-backend` (또는 원하는 이름)
   - Virtual CPU: 0.25 vCPU
   - Virtual memory: 0.5 GB

5. **Environment variables** 설정:
   - `CLAUDE_API_KEY`: 실제 Claude API 키 입력
   - `GEMINI_API_KEY`: 실제 Gemini API 키 입력

6. **Auto scaling** 설정:
   - Min size: 1
   - Max size: 3

7. **Health check** 설정:
   - Health check path: `/health`

8. "Create & deploy" 클릭

### 1.3 배포 확인
- 배포 완료 후 제공되는 App Runner URL 기록
- `https://your-app-runner-url.region.awsapprunner.com/health` 접속하여 확인

## 2. 프론트엔드 배포 (Amplify) - 5분

### 2.1 Amplify 앱 생성
1. AWS 콘솔에서 Amplify 서비스로 이동
2. "Create new app" → "Host web app" 클릭
3. **Deploy your app** 설정:
   - From your existing code: GitHub 선택
   - GitHub 연결 및 리포지토리 선택
   - Branch: main
   - App name: `mindmap-frontend`

### 2.2 빌드 설정
1. **Build settings** 확인:
   - `mindmap-app/amplify.yml` 파일이 자동으로 감지됨
   - Root directory: `mindmap-app`

2. **Environment variables** 설정:
   - `REACT_APP_API_URL`: App Runner에서 받은 백엔드 URL 입력
   - 예: `https://your-app-runner-url.region.awsapprunner.com`

3. "Save and deploy" 클릭

### 2.3 배포 확인
- 배포 완료 후 제공되는 Amplify URL 기록
- 웹사이트 접속하여 정상 작동 확인

## 3. 도메인 구매 & 설정 (Route 53) - 10분

### 3.1 도메인 구매 (Route 53)
1. AWS 콘솔에서 Route 53 서비스로 이동
2. "Registered domains" → "Register domain" 클릭
3. 원하는 도메인명 검색 및 선택
4. 도메인 정보 입력 및 결제
5. 도메인 등록 완료 (몇 분 소요)

### 3.2 Hosted Zone 설정
1. Route 53 → "Hosted zones" 이동
2. 구매한 도메인의 Hosted zone이 자동 생성됨을 확인
3. NS 레코드와 SOA 레코드가 있는지 확인

### 3.3 도메인 연결
**프론트엔드 도메인 설정:**
1. Amplify 콘솔로 이동
2. 앱 선택 → "Domain management" 클릭
3. "Add domain" 클릭
4. 구매한 도메인 입력 (예: `yourdomain.com`)
5. DNS 설정 자동 구성 확인
6. SSL 인증서 자동 생성 대기

**백엔드 서브도메인 설정:**
1. Route 53 → Hosted zones → 도메인 선택
2. "Create record" 클릭
3. Record settings:
   - Record name: `api` (api.yourdomain.com)
   - Record type: CNAME
   - Value: App Runner URL (https:// 제외)
   - TTL: 300

## 4. SSL & 최종 연결 - 5분

### 4.1 SSL 인증서 확인
1. **Amplify SSL**: 자동으로 생성됨 (Let's Encrypt)
2. **App Runner SSL**: 기본 제공됨

### 4.2 CORS 설정 업데이트
백엔드 코드에서 CORS 설정을 업데이트해야 합니다:

```python
# backend/main.py에서 CORS 설정 수정
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000", 
        "http://localhost:3003",
        "https://yourdomain.com",  # 실제 도메인으로 변경
        "https://www.yourdomain.com"  # www 서브도메인도 추가
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### 4.3 프론트엔드 API URL 업데이트
프론트엔드에서 백엔드 API URL을 업데이트:

1. Amplify 환경변수에서 `REACT_APP_API_URL`을 `https://api.yourdomain.com`으로 변경
2. 또는 코드에서 직접 수정

### 4.4 최종 테스트
1. `https://yourdomain.com` 접속
2. 모든 기능이 정상 작동하는지 확인
3. API 호출이 정상적으로 이루어지는지 확인

## 비용 예상

### 월 예상 비용 (최소 사용량 기준):
- **App Runner**: $7-15/월 (0.25 vCPU, 0.5GB RAM)
- **Amplify**: $1-5/월 (빌드 시간 + 호스팅)
- **Route 53**: $0.50/월 (Hosted Zone) + 도메인 등록비
- **도메인**: $10-15/년 (.com 기준)

### 총 예상 비용: $20-40/월

## 문제 해결

### 일반적인 문제들:

1. **App Runner 빌드 실패**:
   - `requirements.txt` 파일 확인
   - Python 버전 호환성 확인
   - 환경변수 설정 확인

2. **Amplify 빌드 실패**:
   - `package.json` 의존성 확인
   - Node.js 버전 호환성 확인
   - 빌드 로그 확인

3. **CORS 에러**:
   - 백엔드 CORS 설정에 프론트엔드 도메인 추가
   - 프리플라이트 요청 허용 확인

4. **API 연결 실패**:
   - 네트워크 탭에서 요청 URL 확인
   - 백엔드 서비스 상태 확인
   - 환경변수 설정 확인

## 모니터링 및 로그

1. **App Runner**: CloudWatch 로그 자동 생성
2. **Amplify**: 빌드 로그 및 액세스 로그 제공
3. **Route 53**: 쿼리 로깅 설정 가능

## 보안 고려사항

1. API 키는 환경변수로만 관리
2. HTTPS 강제 사용
3. CORS 설정을 최소한으로 제한
4. 정기적인 의존성 업데이트

이 가이드를 따라하면 약 30분 내에 전체 애플리케이션을 AWS에 배포할 수 있습니다.
