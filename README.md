# AI Reigns - Interactive Story Game

AI를 활용한 Reigns 스타일 인터랙티브 스토리 게임 프로젝트입니다.

## 🎮 프로젝트 개요

이 프로젝트는 AI(Claude, Gemini)를 활용하여 동적으로 스토리를 생성하는 인터랙티브 게임입니다. 사용자는 마인드맵 형태로 스토리 구조를 시각화하고 편집할 수 있으며, 각 선택에 따라 캐릭터의 스탯이 변화합니다.

## 🏗️ 프로젝트 구조

```
ai_reigns_0605/
├── backend/              # FastAPI 백엔드 서버
│   ├── main.py          # 메인 API 서버
│   ├── requirements.txt # Python 의존성
│   ├── railway.json     # Railway 배포 설정
│   ├── Procfile        # Railway 실행 명령
│   └── .env.example    # 환경변수 예시
├── mindmap-app/         # React 프론트엔드
│   ├── src/
│   │   ├── components/  # React 컴포넌트들
│   │   └── App.js      # 메인 앱 컴포넌트
│   ├── vercel.json     # Vercel 배포 설정
│   ├── package.json    # Node.js 의존성
│   └── .env.example    # 환경변수 예시
├── DEPLOYMENT_GUIDE.md  # 배포 가이드
└── README.md           # 이 파일
```

## 🚀 배포된 서비스

- **프론트엔드**: Vercel로 배포
- **백엔드**: Railway로 배포

배포 방법은 [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)를 참조하세요.

## 🛠️ 로컬 개발 환경 설정

### 백엔드 실행

1. backend 디렉토리로 이동:
```bash
cd backend
```

2. 가상환경 생성 및 활성화:
```bash
python -m venv venv
source venv/bin/activate  # macOS/Linux
# 또는 venv\Scripts\activate  # Windows
```

3. 의존성 설치:
```bash
pip install -r requirements.txt
```

4. 환경변수 설정:
```bash
cp .env.example .env
# .env 파일을 편집하여 API 키 설정
```

5. 서버 실행:
```bash
python main.py
```

백엔드 서버가 http://localhost:8000 에서 실행됩니다.

### 프론트엔드 실행

1. mindmap-app 디렉토리로 이동:
```bash
cd mindmap-app
```

2. 의존성 설치:
```bash
npm install
```

3. 환경변수 설정:
```bash
cp .env.example .env
# .env 파일에서 REACT_APP_API_URL 설정
```

4. 개발 서버 실행:
```bash
npm start
```

프론트엔드가 http://localhost:3000 에서 실행됩니다.

## 🔧 기술 스택

### 백엔드
- **FastAPI**: 고성능 Python 웹 프레임워크
- **Pydantic**: 데이터 검증 및 설정 관리
- **httpx**: 비동기 HTTP 클라이언트
- **uvicorn**: ASGI 서버

### 프론트엔드
- **React**: 사용자 인터페이스 라이브러리
- **ReactFlow**: 마인드맵 시각화
- **CSS3**: 스타일링

### AI 서비스
- **Claude API**: Anthropic의 대화형 AI
- **Gemini API**: Google의 생성형 AI

### 배포
- **Vercel**: 프론트엔드 배포 플랫폼
- **Railway**: 백엔드 배포 플랫폼

## 📋 주요 기능

1. **마인드맵 기반 스토리 편집**: 시각적으로 스토리 구조 편집
2. **AI 스토리 생성**: Claude/Gemini API를 활용한 동적 스토리 생성
3. **스탯 시스템**: 선택에 따른 캐릭터 스탯 변화
4. **게임 설정**: 커스터마이징 가능한 게임 설정
5. **실시간 미리보기**: Reigns 스타일 게임 플레이 미리보기

## 🔐 환경 변수 설정

### 백엔드 (.env)
```
CLAUDE_API_KEY=your_claude_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here
```

### 프론트엔드 (.env)
```
REACT_APP_API_URL=http://localhost:8000
```

## 📚 API 문서

백엔드 서버 실행 후 다음 URL에서 API 문서를 확인할 수 있습니다:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## 🤝 기여하기

1. 이 저장소를 포크합니다
2. 새로운 기능 브랜치를 생성합니다 (`git checkout -b feature/amazing-feature`)
3. 변경사항을 커밋합니다 (`git commit -m 'Add some amazing feature'`)
4. 브랜치에 푸시합니다 (`git push origin feature/amazing-feature`)
5. Pull Request를 생성합니다

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.
