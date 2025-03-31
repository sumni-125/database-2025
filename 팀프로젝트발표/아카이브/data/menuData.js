// 낚시터 식당 메뉴 데이터
const menuData = [
  {
    id: 1,
    name: "낚시터 특제 매운탕",
    category: "한식",
    price: 15000,
    description: "직접 잡은 싱싱한 물고기로 끓인 매운탕. 얼큰한 국물이 일품!",
    image: "https://images.unsplash.com/photo-1582926978131-037cb8a32f05?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80"
  },
  {
    id: 2,
    name: "낚시꾼 도시락",
    category: "한식",
    price: 10000,
    description: "간편하게 즐길 수 있는 낚시꾼을 위한 도시락. 밥과 반찬이 푸짐하게 담겨 있습니다.",
    image: "https://images.unsplash.com/photo-1607301406259-dfb186e15de8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1364&q=80"
  },
  {
    id: 3,
    name: "낚시터 김치찌개",
    category: "한식",
    price: 12000,
    description: "구수한 김치와 함께 끓인 찌개. 추운 날 낚시 후 먹기 좋은 메뉴입니다.",
    image: "https://images.unsplash.com/photo-1627476462582-68808679948a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80"
  },
  {
    id: 4,
    name: "생선구이 정식",
    category: "한식",
    price: 18000,
    description: "직접 잡은 물고기를 숯불에 구운 정식. 밥과 반찬이 함께 제공됩니다.",
    image: "https://images.unsplash.com/photo-1580217593608-61931cefc821?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1364&q=80"
  },
  {
    id: 5,
    name: "해물파스타",
    category: "양식",
    price: 16000,
    description: "신선한 해물과 알덴테로 삶은 파스타. 토마토 또는 크림 소스 중 선택 가능합니다.",
    image: "https://images.unsplash.com/photo-1563379926898-05f4575a45d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80"
  },
  {
    id: 6,
    name: "낚시터 버거",
    category: "양식",
    price: 13000,
    description: "두툼한 패티와 특제 소스가 들어간 버거. 감자튀김 포함.",
    image: "https://images.unsplash.com/photo-1586190848861-99aa4a171e90?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1480&q=80"
  },
  {
    id: 7,
    name: "생선 샐러드",
    category: "양식",
    price: 14000,
    description: "신선한 채소와 함께 즐기는 훈제 생선 샐러드. 건강한 한 끼 식사로 좋습니다.",
    image: "https://images.unsplash.com/photo-1546039907-7fa05f864c02?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80"
  },
  {
    id: 8,
    name: "생선 스테이크",
    category: "양식",
    price: 20000,
    description: "두툼하게 썬 생선을 팬에 구운 스테이크. 레몬 버터 소스와 함께 제공됩니다.",
    image: "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80"
  }
];

// 낚시꾼 데이터 - 낚시꾼 코드 목록
const fishermen = [
  { code: "A001", name: "홍길동" },
  { code: "A002", name: "김영희" },
  { code: "A003", name: "박철수" },
  { code: "A004", name: "이민수" },
  { code: "A005", name: "최다혜" }
]; 