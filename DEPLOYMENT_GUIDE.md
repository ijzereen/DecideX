# 배포 가이드

이 프로젝트는 프론트엔드를 Vercel로, 백엔드를 Railway로 배포하도록 설정되어 있습니다.

## 🚀 백엔드 배포 (Railway)

### 1. Railway 계정 생성 및 프로젝트 설정

1. [Railway](https://railway.app)에 가입하고 로그인
2. "New Project" 클릭
3. "Deploy from GitHub repo" 선택
4. 이 저장소를 선택하고 `backend` 폴더를 루트로 설정

### 2. 환경 변수 설정

Railway 대시보드에서 다음 환경 변수들을 설정하세요:

```
CLAUDE_API_KEY=your_claude_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here
PORT=8000
```

### 3. 배포 확인

- Railway가 자동으로 `Procfile`을 감지하여 배포합니다
- 배포 완료 후 제공되는 URL을 기록해두세요 (예: `https://your-app-name.railway.app`)
- `/health` 엔드포인트로 헬스체크 가능

## 🌐 프론트엔드 배포 (Vercel)

### 1. Vercel 계정 생성 및 프로젝트 설정

1. [Vercel](https://vercel.com)에 가입하고 로그인
2. "New Project" 클릭
3. GitHub 저장소를 연결
4. 프로젝트 설정에서:
   - **Framework Preset**: Create React App
   - **Root Directory**: `mindmap-app`
   - **Build Command**: `npm run build`
   - **Output Directory**: `build`

### 2. 환경 변수 설정

Vercel 대시보드의 Settings > Environment Variables에서:

```
REACT_APP_API_URL=https://your-railway-app-url.railway.app
```

**중요**: Railway 백엔드 배포 완료 후 실제 URL로 변경하세요.

### 3. 배포 확인

- Vercel이 자동으로 빌드하고 배포합니다
- 배포 완료 후 제공되는 URL로 접속하여 확인

## 🔧 로컬 개발 환경 설정

### 백엔드 실행

```bash
cd backend
pip install -r requirements.txt
cp .env.example .env
# .env 파일에 API 키 설정
python main.py
```

### 프론트엔드 실행

```bash
cd mindmap-app
npm install
cp .env.example .env
# .env 파일에 백엔드 URL 설정 (로컬: http://localhost:8000)
npm start
```

## 📋 배포 체크리스트

### 백엔드 (Railway)
- [ ] Railway 프로젝트 생성
- [ ] 환경 변수 설정 (CLAUDE_API_KEY, GEMINI_API_KEY)
- [ ] 배포 성공 확인
- [ ] `/health` 엔드포인트 테스트
- [ ] CORS 설정 확인

### 프론트엔드 (Vercel)
- [ ] Vercel 프로젝트 생성
- [ ] 빌드 설정 확인
- [ ] 환경 변수 설정 (REACT_APP_API_URL)
- [ ] 배포 성공 확인
- [ ] API 연결 테스트

## 🔍 트러블슈팅

### 일반적인 문제들

1. **CORS 에러**
   - 백엔드의 `main.py`에서 프론트엔드 도메인이 CORS 설정에 포함되어 있는지 확인
   - Vercel 도메인 패턴: `https://*.vercel.app`

2. **API 연결 실패**
   - 프론트엔드의 `REACT_APP_API_URL` 환경 변수가 올바른 Railway URL로 설정되어 있는지 확인
   - Railway 백엔드가 정상 작동하는지 `/health` 엔드포인트로 확인

3. **빌드 실패**
   - Node.js 버전 호환성 확인
   - 의존성 설치 문제 시 `package-lock.json` 삭제 후 재설치

4. **환경 변수 문제**
   - Railway: 환경 변수 설정 후 재배포 필요
   - Vercel: 환경 변수 변경 후 재배포 필요

## 📚 추가 리소스

- [Railway 문서](https://docs.railway.app/)
- [Vercel 문서](https://vercel.com/docs)
- [FastAPI 배포 가이드](https://fastapi.tiangolo.com/deployment/)
- [Create React App 배포 가이드](https://create-react-app.dev/docs/deployment/)

## 🔐 보안 고려사항

1. **API 키 보안**
   - API 키는 절대 코드에 하드코딩하지 마세요
   - 환경 변수로만 관리하세요

2. **CORS 설정**
   - 운영 환경에서는 `"*"` 대신 특정 도메인만 허용하세요
   - 현재 설정에서 개발용 `"*"` 설정을 제거하는 것을 고려하세요

3. **HTTPS 사용**
   - 모든 API 통신은 HTTPS를 사용하세요
   - Railway와 Vercel 모두 기본적으로 HTTPS를 제공합니다
