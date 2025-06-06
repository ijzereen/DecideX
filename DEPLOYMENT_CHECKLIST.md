# AWS 배포 체크리스트 ✅

이 체크리스트를 따라하면 30분 내에 전체 애플리케이션을 AWS에 배포할 수 있습니다.

## 사전 준비 (5분)

### ✅ 필수 요구사항
- [ ] AWS 계정 생성 및 로그인
- [ ] GitHub 계정 및 리포지토리 준비
- [ ] Claude API 키 준비 (선택사항)
- [ ] Gemini API 키 준비 (선택사항)

### ✅ 로컬 환경 확인
- [ ] Git 설치 및 설정
- [ ] AWS CLI 설치 (선택사항)
- [ ] 프로젝트를 GitHub에 푸시

```bash
# 프로젝트를 GitHub에 푸시
git add .
git commit -m "Ready for AWS deployment"
git push origin main
```

## 1. 백엔드 배포 (App Runner) - 10분

### ✅ App Runner 서비스 생성
1. **AWS 콘솔 접속**
   - [ ] [AWS App Runner 콘솔](https://console.aws.amazon.com/apprunner/) 이동
   - [ ] "Create service" 클릭

2. **소스 설정**
   - [ ] Repository type: **GitHub** 선택
   - [ ] "Connect to GitHub" 클릭하여 GitHub 계정 연결
   - [ ] Repository: 프로젝트 리포지토리 선택
   - [ ] Branch: **main** 선택
   - [ ] Deployment trigger: **Automatic** 선택

3. **빌드 설정**
   - [ ] Configuration file: **Use configuration file** 선택
   - [ ] Configuration file location: `backend/apprunner.yaml`

4. **서비스 설정**
   - [ ] Service name: `mindmap-backend` (또는 원하는 이름)
   - [ ] Virtual CPU: **0.25 vCPU**
   - [ ] Virtual memory: **0.5 GB**

5. **환경변수 설정**
   - [ ] `CLAUDE_API_KEY`: 실제 Claude API 키 입력
   - [ ] `GEMINI_API_KEY`: 실제 Gemini API 키 입력

6. **고급 설정**
   - [ ] Auto scaling - Min size: **1**
   - [ ] Auto scaling - Max size: **3**
   - [ ] Health check path: `/health`

7. **배포 실행**
   - [ ] "Create & deploy" 클릭
   - [ ] 배포 완료까지 대기 (약 5-8분)
   - [ ] **App Runner URL 기록**: `https://xxxxxxxxx.region.awsapprunner.com`

### ✅ 백엔드 테스트
- [ ] `https://your-app-runner-url/health` 접속하여 정상 응답 확인
- [ ] 응답 예시: `{"status": "healthy", "timestamp": "...", ...}`

## 2. 프론트엔드 배포 (Amplify) - 5분

### ✅ Amplify 앱 생성
1. **AWS 콘솔 접속**
   - [ ] [AWS Amplify 콘솔](https://console.aws.amazon.com/amplify/) 이동
   - [ ] "Create new app" → "Host web app" 클릭

2. **소스 설정**
   - [ ] "From your existing code" → **GitHub** 선택
   - [ ] GitHub 계정 연결 (이미 연결된 경우 스킵)
   - [ ] Repository: 동일한 프로젝트 리포지토리 선택
   - [ ] Branch: **main** 선택

3. **앱 설정**
   - [ ] App name: `mindmap-frontend`
   - [ ] Root directory: `mindmap-app`

4. **빌드 설정**
   - [ ] `mindmap-app/amplify.yml` 파일이 자동 감지되는지 확인
   - [ ] Build settings가 올바른지 확인

5. **환경변수 설정**
   - [ ] `REACT_APP_API_URL`: App Runner URL 입력
   - [ ] 예: `https://xxxxxxxxx.region.awsapprunner.com`

6. **배포 실행**
   - [ ] "Save and deploy" 클릭
   - [ ] 배포 완료까지 대기 (약 3-5분)
   - [ ] **Amplify URL 기록**: `https://xxxxxxxxx.amplifyapp.com`

### ✅ 프론트엔드 테스트
- [ ] Amplify URL 접속하여 웹사이트 로드 확인
- [ ] 기본 기능 테스트 (노드 생성, 연결 등)

## 3. 도메인 구매 & 설정 (Route 53) - 10분

### ✅ 도메인 구매 (선택사항)
1. **Route 53에서 도메인 구매**
   - [ ] [Route 53 콘솔](https://console.aws.amazon.com/route53/) 이동
   - [ ] "Registered domains" → "Register domain" 클릭
   - [ ] 원하는 도메인명 검색 및 선택
   - [ ] 도메인 정보 입력 및 결제
   - [ ] 도메인 등록 완료 확인

2. **Hosted Zone 확인**
   - [ ] "Hosted zones"에서 도메인의 Hosted zone 자동 생성 확인
   - [ ] NS 레코드와 SOA 레코드 존재 확인

### ✅ 도메인 연결
1. **프론트엔드 도메인 설정**
   - [ ] Amplify 콘솔 → 앱 선택 → "Domain management"
   - [ ] "Add domain" 클릭
   - [ ] 구매한 도메인 입력 (예: `yourdomain.com`)
   - [ ] DNS 설정 자동 구성 확인
   - [ ] SSL 인증서 생성 대기

2. **백엔드 서브도메인 설정**
   - [ ] Route 53 → Hosted zones → 도메인 선택
   - [ ] "Create record" 클릭
   - [ ] Record name: `api`
   - [ ] Record type: **CNAME**
   - [ ] Value: App Runner URL (https:// 제외)
   - [ ] TTL: **300**

## 4. SSL & 최종 연결 - 5분

### ✅ SSL 인증서 확인
- [ ] Amplify: SSL 인증서 자동 생성 확인
- [ ] App Runner: 기본 SSL 제공 확인

### ✅ CORS 설정 업데이트
- [ ] `backend/main.py`에서 CORS 설정에 도메인 추가:
```python
allow_origins=[
    "http://localhost:3000", 
    "http://localhost:3003",
    "https://*.amplifyapp.com",
    "https://*.amazonaws.com",
    "https://yourdomain.com",      # 실제 도메인
    "https://www.yourdomain.com"   # www 서브도메인
],
```

### ✅ 최종 테스트
- [ ] `https://yourdomain.com` 접속 확인
- [ ] `https://api.yourdomain.com/health` API 확인
- [ ] 프론트엔드에서 백엔드 API 호출 테스트
- [ ] 모든 기능 정상 작동 확인

## 배포 완료 확인

### ✅ 최종 체크리스트
- [ ] 백엔드 API 정상 작동
- [ ] 프론트엔드 웹사이트 정상 로드
- [ ] API 연동 정상 작동
- [ ] SSL 인증서 적용 확인
- [ ] 커스텀 도메인 연결 (선택사항)

### ✅ 배포 정보 기록
```
배포 완료 정보:
- 백엔드 URL: https://xxxxxxxxx.region.awsapprunner.com
- 프론트엔드 URL: https://xxxxxxxxx.amplifyapp.com
- 커스텀 도메인: https://yourdomain.com (선택사항)
- 배포 날짜: YYYY-MM-DD
```

## 문제 해결

### 🔧 일반적인 문제들
- **App Runner 빌드 실패**: `requirements.txt` 확인, Python 버전 호환성
- **Amplify 빌드 실패**: `package.json` 의존성 확인, Node.js 버전
- **CORS 에러**: 백엔드 CORS 설정에 프론트엔드 도메인 추가
- **API 연결 실패**: 환경변수 `REACT_APP_API_URL` 확인

### 📞 지원 리소스
- [AWS App Runner 문서](https://docs.aws.amazon.com/apprunner/)
- [AWS Amplify 문서](https://docs.aws.amazon.com/amplify/)
- [Route 53 문서](https://docs.aws.amazon.com/route53/)

## 비용 관리

### 💰 예상 월 비용
- **App Runner**: $7-15 (0.25 vCPU, 0.5GB RAM)
- **Amplify**: $1-5 (빌드 + 호스팅)
- **Route 53**: $0.50 (Hosted Zone)
- **도메인**: $10-15/년 (.com 기준)
- **총합**: 약 $20-40/월

### 📊 비용 모니터링
- [ ] AWS Cost Explorer 설정
- [ ] 예산 알림 설정
- [ ] 정기적인 비용 검토

---

🎉 **축하합니다!** 성공적으로 AWS에 풀스택 애플리케이션을 배포했습니다!
