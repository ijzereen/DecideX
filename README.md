# AI Reigns - Interactive Story Generator

AI를 활용한 인터랙티브 스토리 생성 플랫폼입니다. 마인드맵 형태로 스토리를 구성하고, AI가 자동으로 스토리를 생성해주는 웹 애플리케이션입니다.

## 🌟 주요 기능

- **마인드맵 기반 스토리 구성**: ReactFlow를 사용한 직관적인 노드 기반 스토리 편집
- **AI 스토리 생성**: Claude 및 Gemini API를 활용한 자동 스토리 생성
- **게임 모드**: Reigns 스타일의 인터랙티브 게임 플레이
- **실시간 편집**: 드래그 앤 드롭으로 쉬운 스토리 구조 편집
- **샘플 스토리**: 왕국 스토리, 판타지 모험 등 미리 제작된 템플릿

## 🏗️ 기술 스택

### 프론트엔드
- **React 19**: 최신 React 버전
- **ReactFlow**: 마인드맵 및 노드 기반 UI
- **CSS3**: 커스텀 스타일링

### 백엔드
- **FastAPI**: 고성능 Python 웹 프레임워크
- **Pydantic**: 데이터 검증 및 직렬화
- **httpx**: 비동기 HTTP 클라이언트
- **uvicorn**: ASGI 서버

### AI 통합
- **Claude API**: Anthropic의 대화형 AI
- **Gemini API**: Google의 생성형 AI

## 🚀 로컬 개발 환경 설정

### 사전 요구사항
- Node.js 18+
- Python 3.11+
- Git

### 1. 프로젝트 클론
```bash
git clone <repository-url>
cd ai_reigns_0605
```

### 2. 백엔드 설정
```bash
cd backend

# 가상환경 생성 및 활성화
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 의존성 설치
pip install -r requirements.txt

# 환경변수 설정
cp .env.example .env
# .env 파일에 API 키 입력

# 서버 실행
python main.py
```

### 3. 프론트엔드 설정
```bash
cd mindmap-app

# 의존성 설치
npm install

# 개발 서버 실행
npm start
```

### 4. 접속
- 프론트엔드: http://localhost:3000
- 백엔드 API: http://localhost:8000
- API 문서: http://localhost:8000/docs

## 🌐 AWS 배포

이 프로젝트는 AWS에 완전히 배포할 수 있도록 설정되어 있습니다.

### 빠른 배포 (30분)

1. **체크리스트 확인**
   ```bash
   # 배포 체크리스트 확인
   cat DEPLOYMENT_CHECKLIST.md
   ```

2. **자동 배포 스크립트 실행**
   ```bash
   # 배포 스크립트 실행
   ./deploy-scripts/quick-deploy.sh
   ```

3. **수동 배포 가이드**
   - 상세한 단계별 가이드: [AWS_DEPLOYMENT_GUIDE.md](AWS_DEPLOYMENT_GUIDE.md)
   - 체크리스트: [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)

### 배포 아키텍처

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Route 53      │    │    Amplify       │    │   App Runner    │
│   (DNS)         │───▶│   (Frontend)     │───▶│   (Backend)     │
│                 │    │                  │    │                 │
│ yourdomain.com  │    │ React App        │    │ FastAPI         │
│ api.domain.com  │    │ Static Hosting   │    │ Auto Scaling    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### 배포된 서비스
- **프론트엔드**: AWS Amplify (자동 빌드 및 배포)
- **백엔드**: AWS App Runner (컨테이너 기반 자동 스케일링)
- **도메인**: Route 53 (DNS 관리)
- **SSL**: 자동 인증서 관리

### 예상 비용
- **월 $20-40** (최소 사용량 기준)
- App Runner: $7-15/월
- Amplify: $1-5/월
- Route 53: $0.50/월
- 도메인: $10-15/년

## 📁 프로젝트 구조

```
ai_reigns_0605/
├── backend/                    # FastAPI 백엔드
│   ├── main.py                # 메인 API 서버
│   ├── requirements.txt       # Python 의존성
│   ├── apprunner.yaml        # App Runner 배포 설정
│   └── .env.example          # 환경변수 템플릿
├── mindmap-app/               # React 프론트엔드
│   ├── src/
│   │   ├── App.js            # 메인 애플리케이션
│   │   └── components/       # React 컴포넌트
│   ├── package.json          # Node.js 의존성
│   └── amplify.yml           # Amplify 빌드 설정
├── deploy-scripts/            # 배포 스크립트
│   └── quick-deploy.sh       # 자동 배포 스크립트
├── .github/workflows/         # GitHub Actions
│   └── deploy.yml            # CI/CD 파이프라인
├── AWS_DEPLOYMENT_GUIDE.md    # 상세 배포 가이드
├── DEPLOYMENT_CHECKLIST.md    # 배포 체크리스트
└── README.md                  # 프로젝트 문서
```

## 🎮 사용법

### 1. 스토리 생성
1. 빈 공간을 더블클릭하여 새 노드 생성
2. 노드를 더블클릭하여 편집
3. 노드 간 드래그하여 연결 생성

### 2. AI 스토리 생성
1. 노드 편집 모드에서 "AI 스토리 생성" 버튼 클릭
2. Claude 또는 Gemini API를 통해 자동 스토리 생성
3. 생성된 스토리 검토 및 수정

### 3. 게임 플레이
1. "게임 시작" 버튼 클릭
2. Reigns 스타일의 카드 기반 게임 플레이
3. 선택에 따른 스탯 변화 확인

### 4. 데이터 관리
- **저장**: 로컬 스토리지에 자동 저장
- **내보내기**: JSON 파일로 다운로드
- **가져오기**: JSON 파일에서 로드

## 🔧 API 문서

### 주요 엔드포인트

#### 스토리 생성
```http
POST /api/generate-story
Content-Type: application/json

{
  "currentNode": {...},
  "parentNodes": [...],
  "childNodes": [...],
  "gameConfig": {...},
  "provider": "claude"
}
```

#### 헬스 체크
```http
GET /health

Response:
{
  "status": "healthy",
  "timestamp": "2024-01-01T00:00:00",
  "claude_configured": true,
  "gemini_configured": true
}
```

#### 스토리 분석
```http
POST /api/analyze-story
Content-Type: application/json

{
  "nodes": [...],
  "edges": [...]
}
```

## 🔐 환경변수

### 백엔드 (.env)
```env
CLAUDE_API_KEY=your_claude_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here
```

### 프론트엔드 (Amplify 환경변수)
```env
REACT_APP_API_URL=https://your-backend-url.com
```

## 🤝 기여하기

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 🆘 지원

- **이슈 리포트**: GitHub Issues
- **문서**: [AWS_DEPLOYMENT_GUIDE.md](AWS_DEPLOYMENT_GUIDE.md)
- **체크리스트**: [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)

## 🔄 업데이트 로그

### v1.0.0 (2024-01-01)
- 초기 릴리스
- React + FastAPI 풀스택 구현
- Claude/Gemini AI 통합
- AWS 배포 지원
- 마인드맵 기반 스토리 편집기
- Reigns 스타일 게임 모드

---

**Made with ❤️ using React, FastAPI, and AI**
