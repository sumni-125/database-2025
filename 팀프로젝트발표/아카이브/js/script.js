// DOM 요소 선택
document.addEventListener('DOMContentLoaded', function() {
  // 메인 페이지 요소
  const menuContainer = document.getElementById('menu-container');
  const tabButtons = document.querySelectorAll('.tab-button');
  const searchInput = document.getElementById('search-input');
  const searchButton = document.getElementById('search-button');
  
  // 좌대 예약 페이지 요소
  const platformMap = document.getElementById('platform-map');
  const bookingsTable = document.getElementById('bookings-table');
  const fishermenFilter = document.getElementById('fishermen-filter');
  const platformFilter = document.getElementById('platform-filter');
  const bookingSearch = document.getElementById('booking-search');
  const statsContainer = document.getElementById('stats-container');
  const fishermanChartCanvas = document.getElementById('fisherman-chart');
  const platformChartCanvas = document.getElementById('platform-chart');
  
  // 대회 참가 페이지 요소
  const participationTable = document.getElementById('participation-table');
  const receiveStatusFilter = document.getElementById('receive-status-filter');
  const participationSearch = document.getElementById('participation-search');
  
  // 현재 활성화된 페이지 관리
  let activePage = 'menu'; // 'menu', 'booking', 'participation'
  
  // 페이지 전환 함수
  function switchPage(pageName) {
    document.querySelectorAll('.page').forEach(page => {
      page.style.display = 'none';
    });
    document.getElementById(`${pageName}-page`).style.display = 'block';
    activePage = pageName;
    
    // 페이지에 맞는 초기화 함수 호출
    if (pageName === 'menu') {
      initMenuPage();
    } else if (pageName === 'booking') {
      initBookingPage();
    } else if (pageName === 'participation') {
      initParticipationPage();
    }
  }
  
  // 네비게이션 이벤트 리스너 설정
  document.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', function(e) {
      e.preventDefault();
      const page = this.getAttribute('data-page');
      switchPage(page);
    });
  });
  
  // ====================== 메뉴 페이지 기능 ====================== //
  
  function initMenuPage() {
    renderMenus();
    
    // 탭 버튼 이벤트 리스너 설정
    tabButtons.forEach(button => {
      button.addEventListener('click', function() {
        const category = this.getAttribute('data-category');
        
        // 활성화된 탭 표시
        tabButtons.forEach(btn => btn.classList.remove('active'));
        this.classList.add('active');
        
        // 메뉴 필터링 및 렌더링
        filterMenusByCategory(category);
      });
    });
    
    // 검색 기능
    if (searchButton) {
      searchButton.addEventListener('click', function() {
        searchMenus();
      });
    }
    
    if (searchInput) {
      searchInput.addEventListener('keyup', function(e) {
        if (e.key === 'Enter') {
          searchMenus();
        }
      });
    }
  }
  
  // 모든 메뉴 렌더링
  function renderMenus(filteredMenus = null) {
    if (!menuContainer) return;
    
    const menus = filteredMenus || menuData;
    menuContainer.innerHTML = '';
    
    menus.forEach(menu => {
      const menuCard = document.createElement('div');
      menuCard.className = 'menu-card';
      menuCard.innerHTML = `
        <div class="menu-image">
          <img src="${menu.image}" alt="${menu.name}">
        </div>
        <div class="menu-info">
          <h3>${menu.name}</h3>
          <p class="menu-category">${menu.category}</p>
          <p class="menu-price">${menu.price.toLocaleString()}원</p>
          <p class="menu-description">${menu.description}</p>
          <button class="order-button" data-menu-id="${menu.id}">주문하기 🛒</button>
        </div>
      `;
      menuContainer.appendChild(menuCard);
      
      // 주문 버튼 이벤트 리스너
      const orderButton = menuCard.querySelector('.order-button');
      orderButton.addEventListener('click', function() {
        const menuId = this.getAttribute('data-menu-id');
        showOrderModal(menuId);
      });
    });
  }
  
  // 카테고리로 메뉴 필터링
  function filterMenusByCategory(category) {
    if (category === '전체') {
      renderMenus();
    } else {
      const filteredMenus = menuData.filter(menu => menu.category === category);
      renderMenus(filteredMenus);
    }
  }
  
  // 메뉴 검색
  function searchMenus() {
    if (!searchInput) return;
    
    const searchTerm = searchInput.value.trim().toLowerCase();
    if (searchTerm === '') {
      renderMenus();
      return;
    }
    
    const filteredMenus = menuData.filter(menu => 
      menu.name.toLowerCase().includes(searchTerm) || 
      menu.description.toLowerCase().includes(searchTerm)
    );
    
    renderMenus(filteredMenus);
  }
  
  // 주문 모달 표시
  function showOrderModal(menuId) {
    const menu = menuData.find(m => m.id == menuId);
    if (!menu) return;
    
    // 모달 생성
    const modal = document.createElement('div');
    modal.className = 'modal';
    modal.innerHTML = `
      <div class="modal-content">
        <span class="close-button">&times;</span>
        <h2>주문하기</h2>
        <div class="order-details">
          <img src="${menu.image}" alt="${menu.name}" class="modal-image">
          <h3>${menu.name}</h3>
          <p class="menu-price">${menu.price.toLocaleString()}원</p>
          <p>${menu.description}</p>
          <div class="order-form">
            <label for="quantity">수량:</label>
            <input type="number" id="quantity" min="1" value="1">
            <label for="fisher-code">낚시꾼 코드:</label>
            <select id="fisher-code">
              ${fishermen.map(fisher => `<option value="${fisher.code}">${fisher.code} - ${fisher.name}</option>`).join('')}
            </select>
            <p class="total-price">총 가격: <span>${menu.price.toLocaleString()}</span>원</p>
            <button id="confirm-order" class="primary-button">주문 확인</button>
          </div>
        </div>
      </div>
    `;
    
    document.body.appendChild(modal);
    
    // 수량 변경 시 총 가격 업데이트
    const quantityInput = modal.querySelector('#quantity');
    const totalPriceSpan = modal.querySelector('.total-price span');
    
    quantityInput.addEventListener('change', function() {
      const quantity = parseInt(this.value) || 1;
      const totalPrice = menu.price * quantity;
      totalPriceSpan.textContent = totalPrice.toLocaleString();
    });
    
    // 닫기 버튼 이벤트
    const closeButton = modal.querySelector('.close-button');
    closeButton.addEventListener('click', function() {
      document.body.removeChild(modal);
    });
    
    // 모달 바깥 클릭시 닫기
    modal.addEventListener('click', function(e) {
      if (e.target === modal) {
        document.body.removeChild(modal);
      }
    });
    
    // 주문 확인 버튼 이벤트
    const confirmButton = modal.querySelector('#confirm-order');
    confirmButton.addEventListener('click', function() {
      const quantity = parseInt(quantityInput.value) || 1;
      const fisherCode = modal.querySelector('#fisher-code').value;
      const fisherName = fishermen.find(f => f.code === fisherCode)?.name || '';
      
      // 주문 처리 로직 (실제로는 서버로 전송)
      alert(`주문이 완료되었습니다!\n메뉴: ${menu.name}\n수량: ${quantity}\n낚시꾼: ${fisherName}(${fisherCode})\n총 가격: ${(menu.price * quantity).toLocaleString()}원`);
      
      document.body.removeChild(modal);
    });
  }
  
  // ====================== 좌대 예약 페이지 기능 ====================== //
  
  function initBookingPage() {
    // 필터 옵션 초기화
    initFilterOptions();
    
    // 좌대 맵 렌더링
    renderPlatformMap();
    
    // 예약 목록 렌더링
    renderBookingsTable();
    
    // 통계 및 차트 렌더링
    updateStats();
    renderCharts();
    
    // 이벤트 리스너 설정
    fishermenFilter.addEventListener('change', filterBookings);
    platformFilter.addEventListener('change', filterBookings);
    bookingSearch.addEventListener('input', filterBookings);
    
    // 무작위 물고기 애니메이션
    startRandomFishAnimation();
  }
  
  // 필터 옵션 초기화
  function initFilterOptions() {
    // 낚시꾼 필터 옵션 추가
    const uniqueFishermen = [];
    const uniqueFishermenMap = new Map();
    
    bookingData.bookings.forEach(booking => {
      if (!uniqueFishermenMap.has(booking["낚시꾼 코드"])) {
        uniqueFishermenMap.set(booking["낚시꾼 코드"], booking["낚시꾼 이름"]);
        uniqueFishermen.push({
          code: booking["낚시꾼 코드"],
          name: booking["낚시꾼 이름"]
        });
      }
    });
    
    fishermenFilter.innerHTML = '<option value="">전체 낚시꾼</option>';
    uniqueFishermen.forEach(fisher => {
      fishermenFilter.innerHTML += `<option value="${fisher.code}">${fisher.name} (${fisher.code})</option>`;
    });
    
    // 좌대 필터 옵션 추가
    const uniquePlatforms = [];
    bookingData.platforms.forEach(platform => {
      if (!uniquePlatforms.includes(platform.F_NUM)) {
        uniquePlatforms.push(platform.F_NUM);
      }
    });
    
    platformFilter.innerHTML = '<option value="">전체 좌대</option>';
    uniquePlatforms.sort((a, b) => a - b).forEach(platform => {
      platformFilter.innerHTML += `<option value="${platform}">${platform}</option>`;
    });
  }
  
  // 좌대 맵 렌더링
  function renderPlatformMap() {
    platformMap.innerHTML = '';
    
    // 배경 이미지와 호수 형태 추가
    const lake = document.createElement('div');
    lake.className = 'lake';
    platformMap.appendChild(lake);
    
    // 좌대 추가
    bookingData.platforms.forEach(platform => {
      const platformElement = document.createElement('div');
      platformElement.className = 'platform';
      platformElement.dataset.platformNum = platform.F_NUM;
      
      // 좌대 위치 설정
      platformElement.style.top = platform.position.top;
      platformElement.style.left = platform.position.left;
      
      // 좌대가 예약됐는지 확인
      const isReserved = bookingData.bookings.some(booking => 
        booking["좌대 번호"] === platform.F_NUM
      );
      
      if (isReserved) {
        platformElement.classList.add('reserved');
      }
      
      platformElement.innerHTML = `
        <span class="platform-number">${platform.F_NUM}</span>
        <div class="platform-tooltip">
          <h4>좌대 ${platform.F_NUM}</h4>
          <p>가격: ${platform.PRICE.toLocaleString()}원</p>
          <p>상태: ${isReserved ? '예약됨' : '예약 가능'}</p>
          ${isReserved ? `<p>예약자: ${getReservedFishermen(platform.F_NUM).join(', ')}</p>` : ''}
        </div>
      `;
      
      platformMap.appendChild(platformElement);
    });
    
    // 무작위 물고기 추가
    for (let i = 0; i < 5; i++) {
      addRandomFish();
    }
  }
  
  // 특정 좌대를 예약한 낚시꾼 이름 가져오기
  function getReservedFishermen(platformNum) {
    const reservations = bookingData.bookings.filter(
      booking => booking["좌대 번호"] === platformNum
    );
    
    const uniqueFishermen = [];
    const fishermenMap = new Map();
    
    reservations.forEach(reservation => {
      const fisherCode = reservation["낚시꾼 코드"];
      if (!fishermenMap.has(fisherCode)) {
        fishermenMap.set(fisherCode, reservation["낚시꾼 이름"]);
        uniqueFishermen.push(reservation["낚시꾼 이름"]);
      }
    });
    
    return uniqueFishermen;
  }
  
  // 예약 목록 테이블 렌더링
  function renderBookingsTable(filteredBookings = null) {
    const bookings = filteredBookings || bookingData.bookings;
    const tbody = bookingsTable.querySelector('tbody');
    tbody.innerHTML = '';
    
    bookings.forEach(booking => {
      const tr = document.createElement('tr');
      const totalPrice = booking["좌대 가격"] * booking["예약 일수"];
      
      tr.innerHTML = `
        <td>${booking["낚시꾼 코드"]}</td>
        <td>${booking["낚시꾼 이름"]}</td>
        <td>${booking["예약 코드"]}</td>
        <td>${booking["좌대 번호"]}</td>
        <td>${booking["좌대 가격"].toLocaleString()}원</td>
        <td>${booking["예약 일수"]}일</td>
        <td>${totalPrice.toLocaleString()}원</td>
      `;
      
      tbody.appendChild(tr);
    });
  }
  
  // 통계 업데이트
  function updateStats(filteredBookings = null) {
    const bookings = filteredBookings || bookingData.bookings;
    
    // 총 예약 수
    const totalBookings = bookings.length;
    
    // 총 예약 일수
    const totalDays = bookings.reduce((sum, booking) => sum + booking["예약 일수"], 0);
    
    // 총 예약 금액
    const totalAmount = bookings.reduce((sum, booking) => 
      sum + (booking["좌대 가격"] * booking["예약 일수"]), 0
    );
    
    // 가장 많이 예약된 좌대
    const platformCounts = {};
    bookings.forEach(booking => {
      const platformNum = booking["좌대 번호"];
      platformCounts[platformNum] = (platformCounts[platformNum] || 0) + 1;
    });
    
    let mostPopularPlatform = '없음';
    let maxCount = 0;
    
    for (const platform in platformCounts) {
      if (platformCounts[platform] > maxCount) {
        maxCount = platformCounts[platform];
        mostPopularPlatform = platform;
      }
    }
    
    // 통계 표시
    document.getElementById('total-bookings').textContent = totalBookings;
    document.getElementById('total-days').textContent = totalDays;
    document.getElementById('total-amount').textContent = totalAmount.toLocaleString() + '원';
    document.getElementById('popular-platform').textContent = mostPopularPlatform;
  }
  
  // 차트 렌더링
  function renderCharts(filteredBookings = null) {
    const bookings = filteredBookings || bookingData.bookings;
    
    // 낚시꾼별 예약 현황 차트
    const fishermenCounts = {};
    const fishermenColors = {
      '홍길동': '#FF6384',
      '김영희': '#36A2EB',
      '박철수': '#FFCE56',
      '이민수': '#4BC0C0',
      '최다혜': '#9966FF'
    };
    
    bookings.forEach(booking => {
      const fisherName = booking["낚시꾼 이름"];
      fishermenCounts[fisherName] = (fishermenCounts[fisherName] || 0) + 1;
    });
    
    const fishermenNames = Object.keys(fishermenCounts);
    const fishermenData = Object.values(fishermenCounts);
    const fishermenChartColors = fishermenNames.map(name => fishermenColors[name] || '#' + Math.floor(Math.random()*16777215).toString(16));
    
    if (window.fishermenChart) {
      window.fishermenChart.destroy();
    }
    
    window.fishermenChart = new Chart(fishermanChartCanvas, {
      type: 'pie',
      data: {
        labels: fishermenNames,
        datasets: [{
          data: fishermenData,
          backgroundColor: fishermenChartColors,
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: 'bottom',
          },
          title: {
            display: true,
            text: '낚시꾼별 예약 현황'
          }
        }
      }
    });
    
    // 좌대별 예약 현황 차트
    const platformCounts = {};
    bookings.forEach(booking => {
      const platformNum = booking["좌대 번호"];
      platformCounts[platformNum] = (platformCounts[platformNum] || 0) + 1;
    });
    
    const platformNumbers = Object.keys(platformCounts);
    const platformData = Object.values(platformCounts);
    
    if (window.platformsChart) {
      window.platformsChart.destroy();
    }
    
    window.platformsChart = new Chart(platformChartCanvas, {
      type: 'bar',
      data: {
        labels: platformNumbers,
        datasets: [{
          label: '예약 수',
          data: platformData,
          backgroundColor: '#1a759f',
          borderColor: '#1a759f',
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              stepSize: 1
            }
          }
        },
        plugins: {
          title: {
            display: true,
            text: '좌대별 예약 현황'
          }
        }
      }
    });
  }
  
  // 예약 필터링
  function filterBookings() {
    const fisherCode = fishermenFilter.value;
    const platformNum = platformFilter.value ? parseInt(platformFilter.value) : null;
    const searchText = bookingSearch.value.toLowerCase();
    
    const filteredBookings = bookingData.bookings.filter(booking => {
      // 낚시꾼 필터
      const matchesFisher = !fisherCode || booking["낚시꾼 코드"] === fisherCode;
      
      // 좌대 필터
      const matchesPlatform = !platformNum || booking["좌대 번호"] === platformNum;
      
      // 검색어 필터
      const matchesSearch = !searchText || 
        booking["낚시꾼 이름"].toLowerCase().includes(searchText) ||
        booking["낚시꾼 코드"].toLowerCase().includes(searchText) ||
        booking["예약 코드"].toLowerCase().includes(searchText) ||
        booking["좌대 번호"].toString().includes(searchText);
      
      return matchesFisher && matchesPlatform && matchesSearch;
    });
    
    renderBookingsTable(filteredBookings);
    updateStats(filteredBookings);
    renderCharts(filteredBookings);
  }
  
  // 무작위 물고기 애니메이션
  function startRandomFishAnimation() {
    setInterval(addRandomFish, 3000);
  }
  
  function addRandomFish() {
    const fish = document.createElement('div');
    fish.className = 'fish';
    fish.innerHTML = Math.random() > 0.5 ? '🐟' : '🐠';
    
    const size = Math.random() * 1.5 + 0.5; // 0.5 ~ 2배 크기
    fish.style.fontSize = `${size}em`;
    
    const top = Math.random() * 80 + 10; // 10% ~ 90%
    fish.style.top = `${top}%`;
    
    // 왼쪽 또는 오른쪽에서 시작
    const fromLeft = Math.random() > 0.5;
    fish.style.left = fromLeft ? '-50px' : 'calc(100% + 50px)';
    
    // 물고기가 바라볼 방향
    fish.style.transform = `scaleX(${fromLeft ? 1 : -1})`;
    
    // 애니메이션 지속 시간
    const duration = Math.random() * 10 + 10; // 10 ~ 20초
    fish.style.transition = `left ${duration}s linear`;
    
    platformMap.appendChild(fish);
    
    // 다음 프레임에서 애니메이션 시작
    setTimeout(() => {
      fish.style.left = fromLeft ? 'calc(100% + 50px)' : '-50px';
    }, 10);
    
    // 애니메이션이 끝나면 물고기 제거
    setTimeout(() => {
      platformMap.removeChild(fish);
    }, duration * 1000);
  }
  
  // ====================== 대회 참가 페이지 기능 ====================== //
  
  function initParticipationPage() {
    // 참가 목록 렌더링
    renderParticipationTable();
    
    // 이벤트 리스너 설정
    receiveStatusFilter.addEventListener('change', filterParticipation);
    participationSearch.addEventListener('input', filterParticipation);
  }
  
  // 참가 목록 테이블 렌더링
  function renderParticipationTable(filteredData = null) {
    const data = filteredData || participationData;
    const tbody = participationTable.querySelector('tbody');
    tbody.innerHTML = '';
    
    data.forEach(entry => {
      const tr = document.createElement('tr');
      tr.className = entry.received ? 'received' : '';
      
      tr.innerHTML = `
        <td>${entry.fisherCode}</td>
        <td>${entry.fisherName}</td>
        <td>${entry.date}</td>
        <td>${entry.fishCaught}</td>
        <td>${entry.prize}</td>
        <td class="status">${entry.received ? '수령함' : '미수령'}</td>
        <td>${entry.receiveDate || '-'}</td>
        <td class="action">
          ${!entry.received ? 
            `<button class="receive-button" data-id="${entry.id}">수령 처리</button>` : 
            ''}
        </td>
      `;
      
      tbody.appendChild(tr);
    });
    
    // 수령 처리 버튼 이벤트 리스너 추가
    document.querySelectorAll('.receive-button').forEach(button => {
      button.addEventListener('click', function() {
        const id = parseInt(this.getAttribute('data-id'));
        updateReceiveStatus(id);
      });
    });
  }
  
  // 참가 데이터 필터링
  function filterParticipation() {
    const status = receiveStatusFilter.value;
    const searchText = participationSearch.value.toLowerCase();
    
    const filteredData = participationData.filter(entry => {
      // 수령 상태 필터
      const matchesStatus = status === 'all' || 
        (status === 'received' && entry.received) ||
        (status === 'not-received' && !entry.received);
      
      // 검색어 필터
      const matchesSearch = !searchText || 
        entry.fisherCode.toLowerCase().includes(searchText) ||
        entry.fisherName.toLowerCase().includes(searchText) ||
        entry.fishCaught.toLowerCase().includes(searchText) ||
        entry.prize.toLowerCase().includes(searchText);
      
      return matchesStatus && matchesSearch;
    });
    
    renderParticipationTable(filteredData);
  }
  
  // 수령 상태 업데이트
  function updateReceiveStatus(id) {
    // 실제로는 서버로 업데이트 요청을 보내야 함
    // 여기서는 로컬 데이터만 업데이트
    const entry = participationData.find(entry => entry.id === id);
    if (entry) {
      entry.received = true;
      entry.receiveDate = new Date().toISOString().slice(0, 10); // YYYY-MM-DD 형식
      renderParticipationTable();
      
      alert(`${entry.fisherName}님의 ${entry.prize} 수령이 처리되었습니다.`);
    }
  }
  
  // 초기 페이지 설정
  switchPage('menu');
}); 