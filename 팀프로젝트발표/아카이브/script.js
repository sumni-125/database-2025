// DOM 요소
const bookingsTableBody = document.getElementById('bookingsTableBody');
const totalBookingsElement = document.getElementById('totalBookings');
const totalDaysElement = document.getElementById('totalDays');
const popularPlatformElement = document.getElementById('popularPlatform');
const filterFishermanElement = document.getElementById('filterFisherman');
const filterPlatformElement = document.getElementById('filterPlatform');
const searchInput = document.getElementById('searchInput');
const searchBtn = document.getElementById('searchBtn');
const fishermanChartElement = document.getElementById('fishermanChart');
const platformChartElement = document.getElementById('platformChart');
const platformLayoutElement = document.getElementById('platformLayout');

// 데이터
let bookings = [];
let platforms = [];

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
  bookings = bookingData.bookings;
  platforms = bookingData.platforms;
  initializePage();
});

// 페이지 초기화
function initializePage() {
  populateFilterOptions();
  renderTable(bookings);
  updateStats();
  renderCharts();
  renderPlatforms();
  addRandomFish();
  
  // 이벤트 리스너 등록
  searchBtn.addEventListener('click', filterBookings);
  searchInput.addEventListener('keyup', function(e) {
    if (e.key === 'Enter') {
      filterBookings();
    }
  });
  
  filterFishermanElement.addEventListener('change', filterBookings);
  filterPlatformElement.addEventListener('change', filterBookings);
}

// 필터 옵션 채우기
function populateFilterOptions() {
  // 낚시꾼 필터 옵션
  const fishermen = [...new Set(bookings.map(item => item['낚시꾼 이름']))];
  fishermen.forEach(fisherman => {
    const option = document.createElement('option');
    option.value = fisherman;
    option.textContent = fisherman;
    filterFishermanElement.appendChild(option);
  });
  
  // 좌대 필터 옵션
  const platformNumbers = [...new Set(bookings.map(item => item['좌대 번호']))];
  platformNumbers.forEach(platform => {
    const option = document.createElement('option');
    option.value = platform;
    option.textContent = platform + '번 좌대';
    filterPlatformElement.appendChild(option);
  });
}

// 테이블 렌더링
function renderTable(data) {
  bookingsTableBody.innerHTML = '';
  
  if (data.length === 0) {
    const noDataRow = document.createElement('tr');
    const noDataCell = document.createElement('td');
    noDataCell.colSpan = 7;
    noDataCell.textContent = '데이터가 없습니다.';
    noDataCell.style.textAlign = 'center';
    noDataRow.appendChild(noDataCell);
    bookingsTableBody.appendChild(noDataRow);
    return;
  }
  
  data.forEach(item => {
    const row = document.createElement('tr');
    
    const fishermanCodeCell = document.createElement('td');
    fishermanCodeCell.textContent = item['낚시꾼 코드'];
    
    const fishermanNameCell = document.createElement('td');
    fishermanNameCell.textContent = item['낚시꾼 이름'];
    
    const bookingCodeCell = document.createElement('td');
    bookingCodeCell.textContent = item['예약 코드'];
    
    const platformNumCell = document.createElement('td');
    platformNumCell.textContent = item['좌대 번호'];
    
    const platformPriceCell = document.createElement('td');
    platformPriceCell.textContent = item['좌대 가격'].toLocaleString() + '원';
    
    const daysCell = document.createElement('td');
    daysCell.textContent = item['예약 일수'] + '일';
    
    const totalPriceCell = document.createElement('td');
    const totalPrice = item['좌대 가격'] * item['예약 일수'];
    totalPriceCell.textContent = totalPrice.toLocaleString() + '원';
    
    row.appendChild(fishermanCodeCell);
    row.appendChild(fishermanNameCell);
    row.appendChild(bookingCodeCell);
    row.appendChild(platformNumCell);
    row.appendChild(platformPriceCell);
    row.appendChild(daysCell);
    row.appendChild(totalPriceCell);
    
    bookingsTableBody.appendChild(row);
  });
}

// 통계 업데이트
function updateStats() {
  // 총 예약 건수
  totalBookingsElement.textContent = bookings.length;
  
  // 총 예약 일수
  const totalDays = bookings.reduce((sum, item) => sum + item['예약 일수'], 0);
  totalDaysElement.textContent = totalDays + '일';
  
  // 가장 인기있는 좌대
  const platformCounts = {};
  bookings.forEach(item => {
    const platformNum = item['좌대 번호'];
    platformCounts[platformNum] = (platformCounts[platformNum] || 0) + 1;
  });
  
  let maxPlatform = 0;
  let maxCount = 0;
  
  for (const platform in platformCounts) {
    if (platformCounts[platform] > maxCount) {
      maxCount = platformCounts[platform];
      maxPlatform = platform;
    }
  }
  
  popularPlatformElement.textContent = `${maxPlatform}번 (${maxCount}회)`;
}

// 좌대 렌더링
function renderPlatforms() {
  platformLayoutElement.innerHTML = '';
  
  // 물고기 애니메이션 추가
  addRandomFish();
  
  // 좌대 위치에 따라 렌더링
  platforms.forEach(platform => {
    const platformElement = document.createElement('div');
    platformElement.className = 'platform';
    platformElement.style.top = platform.position.top;
    platformElement.style.left = platform.position.left;
    
    // 예약된 좌대인지 확인
    const isBooked = bookings.some(booking => booking['좌대 번호'] === platform.F_NUM);
    if (isBooked) {
      platformElement.classList.add('booked');
    }
    
    const platformNumber = document.createElement('div');
    platformNumber.className = 'platform-number';
    platformNumber.textContent = platform.F_NUM;
    
    const platformPrice = document.createElement('div');
    platformPrice.className = 'platform-price';
    platformPrice.textContent = platform.PRICE.toLocaleString() + '원';
    
    // 툴팁 컨테이너 추가
    const tooltipContainer = document.createElement('div');
    tooltipContainer.className = 'tooltip-container';
    
    // 툴팁 정보 추가
    const tooltip = document.createElement('div');
    tooltip.className = 'platform-tooltip';
    
    // 예약 정보 가져오기
    const bookingsForPlatform = bookings.filter(booking => booking['좌대 번호'] === platform.F_NUM);
    if (bookingsForPlatform.length > 0) {
      const bookingItems = bookingsForPlatform.map(booking => 
        `<div class="tooltip-item">${booking['낚시꾼 이름']} (${booking['예약 코드']})<br>${booking['예약 일수']}일</div>`
      ).join('');
      
      tooltip.innerHTML = `<div class="tooltip-header">${platform.F_NUM}번 좌대</div>
                         <div class="tooltip-price">가격: ${platform.PRICE.toLocaleString()}원/일</div>
                         <div class="tooltip-divider"></div>
                         <div class="tooltip-title">예약 현황:</div>
                         <div class="tooltip-bookings">${bookingItems}</div>`;
    } else {
      tooltip.innerHTML = `<div class="tooltip-header">${platform.F_NUM}번 좌대</div>
                         <div class="tooltip-price">가격: ${platform.PRICE.toLocaleString()}원/일</div>
                         <div class="tooltip-divider"></div>
                         <div class="tooltip-bookings">예약 없음</div>`;
    }
    
    tooltipContainer.appendChild(tooltip);
    platformElement.appendChild(platformNumber);
    platformElement.appendChild(platformPrice);
    platformElement.appendChild(tooltipContainer);
    
    // 마우스 올렸을 때 툴팁 위치 동적 조정
    platformElement.addEventListener('mouseenter', function() {
      const topPos = parseInt(platform.position.top);
      const leftPos = parseInt(platform.position.left);
      
      // 좌대의 위치에 따라 툴팁 위치 조정
      // 상단 영역에 있는 경우 (40% 이하)
      if (topPos <= 40) {
        tooltip.style.top = '70px';
        tooltip.style.bottom = 'auto';
        tooltip.classList.add('tooltip-bottom');
      } 
      // 중간 영역에 있는 경우
      else if (topPos > 40 && topPos < 60) {
        if (platform.F_NUM === 1001 || platform.F_NUM === 1002) {
          tooltip.style.top = '70px';
          tooltip.style.bottom = 'auto';
          tooltip.classList.add('tooltip-bottom');
        } else {
          tooltip.style.bottom = '70px';
          tooltip.style.top = 'auto';
          tooltip.classList.remove('tooltip-bottom');
        }
      }
      // 하단 영역에 있는 경우
      else {
        tooltip.style.bottom = '70px';
        tooltip.style.top = 'auto';
        tooltip.classList.remove('tooltip-bottom');
      }
      
      // 좌측에 치우친 경우
      if (leftPos <= 30) {
        tooltip.style.left = '0';
        tooltip.style.transform = 'translateX(0)';
      }
      // 우측에 치우친 경우
      else if (leftPos >= 70) {
        tooltip.style.left = 'auto';
        tooltip.style.right = '0';
        tooltip.style.transform = 'translateX(0)';
      }
      // 가운데 부분
      else {
        tooltip.style.left = '50%';
        tooltip.style.right = 'auto';
        tooltip.style.transform = 'translateX(-50%)';
      }
    });
    
    platformLayoutElement.appendChild(platformElement);
  });
}

// 차트 렌더링
function renderCharts() {
  // 낚시꾼별 예약 차트
  renderFishermanChart();
  
  // 좌대별 인기도 차트
  renderPlatformChart();
}

// 낚시꾼별 예약 차트
function renderFishermanChart() {
  fishermanChartElement.innerHTML = '';
  
  const fishermanCounts = {};
  const fishermanDays = {};
  bookings.forEach(item => {
    const fisherman = item['낚시꾼 이름'];
    fishermanCounts[fisherman] = (fishermanCounts[fisherman] || 0) + 1;
    fishermanDays[fisherman] = (fishermanDays[fisherman] || 0) + item['예약 일수'];
  });
  
  const maxCount = Math.max(...Object.values(fishermanDays));
  
  for (const fisherman in fishermanDays) {
    const days = fishermanDays[fisherman];
    const height = (days / maxCount) * 100;
    
    const bar = document.createElement('div');
    bar.className = 'bar';
    bar.style.height = `${height}%`;
    
    const label = document.createElement('div');
    label.className = 'bar-label';
    label.textContent = fisherman;
    
    const value = document.createElement('div');
    value.className = 'bar-value';
    value.textContent = days + '일';
    
    bar.appendChild(value);
    bar.appendChild(label);
    fishermanChartElement.appendChild(bar);
  }
}

// 좌대별 인기도 차트
function renderPlatformChart() {
  platformChartElement.innerHTML = '';
  
  const platformDays = {};
  platforms.forEach(platform => {
    platformDays[platform.F_NUM] = 0;
  });
  
  bookings.forEach(item => {
    const platform = item['좌대 번호'];
    platformDays[platform] = (platformDays[platform] || 0) + item['예약 일수'];
  });
  
  const maxDays = Math.max(...Object.values(platformDays));
  
  for (const platform in platformDays) {
    const days = platformDays[platform];
    const height = days ? (days / maxDays) * 100 : 0;
    
    const bar = document.createElement('div');
    bar.className = 'bar';
    bar.style.height = `${height}%`;
    
    const label = document.createElement('div');
    label.className = 'bar-label';
    label.textContent = platform + '번';
    
    const value = document.createElement('div');
    value.className = 'bar-value';
    value.textContent = days + '일';
    
    bar.appendChild(value);
    bar.appendChild(label);
    platformChartElement.appendChild(bar);
  }
}

// 좌대 필터링
function filterBookings() {
  const fishermanFilter = filterFishermanElement.value;
  const platformFilter = filterPlatformElement.value;
  const searchQuery = searchInput.value.toLowerCase();
  
  let filteredData = bookings;
  
  // 낚시꾼 필터 적용
  if (fishermanFilter !== 'all') {
    filteredData = filteredData.filter(item => item['낚시꾼 이름'] === fishermanFilter);
  }
  
  // 좌대 필터 적용
  if (platformFilter !== 'all') {
    filteredData = filteredData.filter(item => item['좌대 번호'] === parseInt(platformFilter));
  }
  
  // 검색어 필터 적용
  if (searchQuery) {
    filteredData = filteredData.filter(item => 
      item['낚시꾼 이름'].toLowerCase().includes(searchQuery) ||
      item['낚시꾼 코드'].toLowerCase().includes(searchQuery) ||
      item['예약 코드'].toLowerCase().includes(searchQuery) ||
      item['좌대 번호'].toString().includes(searchQuery)
    );
  }
  
  renderTable(filteredData);
}

// 물고기 애니메이션 추가
function addRandomFish() {
  const lake = document.querySelector('.lake');
  const fishCount = 5;
  const fishTypes = ['🐟', '🐠', '🐡'];
  
  for (let i = 0; i < fishCount; i++) {
    const fish = document.createElement('div');
    fish.className = 'fish';
    fish.textContent = fishTypes[Math.floor(Math.random() * fishTypes.length)];
    fish.style.animationDelay = `${Math.random() * 5}s`;
    fish.style.top = `${20 + Math.random() * 60}%`;
    
    lake.appendChild(fish);
  }
} 