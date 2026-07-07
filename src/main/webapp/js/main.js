/* ============================================
   Travel Rating System - Main JavaScript
   规则: Fetch API 异步 + 滚动入场动画 + 无 window.onscroll
   使用 IntersectionObserver 代替 scroll 事件
   ============================================ */

(function () {
  'use strict';

  /* ---------- DOM Ready ---------- */
  document.addEventListener('DOMContentLoaded', function () {
    initScrollReveal();
    initMobileMenu();
    initVoteButtons();
    initDeleteConfirm();
    initImageFallback();
  });

  /* ---------- Scroll-Reveal Animation ---------- */
  /* 规则: IntersectionObserver 代替 window.addEventListener('scroll') */
  function initScrollReveal() {
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      return;
    }

    const observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry, index) {
          if (entry.isIntersecting) {
            var el = entry.target;
            var delay = parseInt(el.getAttribute('data-delay') || '0', 10);
            setTimeout(function () {
              el.classList.add('revealed');
            }, delay);
            observer.unobserve(el);
          }
        });
      },
      { threshold: 0.15, rootMargin: '0px 0px -40px 0px' }
    );

    document.querySelectorAll('.reveal').forEach(function (el) {
      observer.observe(el);
    });
  }

  /* ---------- Mobile Menu Toggle ---------- */
  function initMobileMenu() {
    var toggle = document.getElementById('mobile-menu-toggle');
    var menu = document.getElementById('mobile-menu');
    if (!toggle || !menu) return;

    toggle.addEventListener('click', function () {
      var expanded = toggle.getAttribute('aria-expanded') === 'true';
      toggle.setAttribute('aria-expanded', !expanded);
      menu.classList.toggle('hidden');

      /* Hamburger → X morph */
      var bars = toggle.querySelectorAll('.menu-bar');
      if (!expanded) {
        bars[0].style.transform = 'translateY(6px) rotate(45deg)';
        bars[1].style.opacity = '0';
        bars[2].style.transform = 'translateY(-6px) rotate(-45deg)';
      } else {
        bars[0].style.transform = '';
        bars[1].style.opacity = '';
        bars[2].style.transform = '';
      }
    });
  }

  /* ---------- Vote / Like Buttons ---------- */
  function initVoteButtons() {
    document.querySelectorAll('.vote-btn').forEach(function (btn) {
      btn.addEventListener('click', function (e) {
        e.preventDefault();
        var destinationId = btn.getAttribute('data-destination-id');
        if (!destinationId) return;

        fetch('/TravelRating/vote?destinationId=' + destinationId, {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
          .then(function (res) {
            if (res.status === 401) {
              window.location.href = '/TravelRating/login.jsp';
              return Promise.reject('unauthorized');
            }
            return res.json();
          })
          .then(function (data) {
            if (data.success) {
              btn.classList.toggle('voted', data.voted);
              var countEl = btn.querySelector('.vote-count');
              if (countEl) countEl.textContent = data.voteCount;
            }
          })
          .catch(function (err) {
            if (err !== 'unauthorized') {
              console.error('Vote error:', err);
            }
          });
      });
    });
  }

  /* ---------- Delete Confirmation ---------- */
  function initDeleteConfirm() {
    document.querySelectorAll('[data-confirm]').forEach(function (el) {
      el.addEventListener('click', function (e) {
        var message = el.getAttribute('data-confirm') || 'Are you sure?';
        if (!confirm(message)) {
          e.preventDefault();
          e.stopPropagation();
        }
      });
    });
  }

  /* ---------- Image Fallback ---------- */
  function initImageFallback() {
    document.querySelectorAll('img[data-fallback]').forEach(function (img) {
      img.addEventListener('error', function () {
        var fallback = img.getAttribute('data-fallback');
        if (fallback && img.src !== fallback) {
          img.src = fallback;
        }
      });
    });
  }

  /* ---------- Search Auto-Submit ---------- */
  var searchForm = document.getElementById('search-form');
  var searchType = document.getElementById('search-type');
  if (searchForm && searchType) {
    searchType.addEventListener('change', function () {
      searchForm.submit();
    });
  }

  /* ---------- Filter Chips ---------- */
  document.querySelectorAll('.chip[data-filter]').forEach(function (chip) {
    chip.addEventListener('click', function () {
      var filter = chip.getAttribute('data-filter');
      var value = chip.getAttribute('data-value');
      var url = new URL(window.location.href);
      url.searchParams.set(filter, value);
      window.location.href = url.toString();
    });
  });

  /* ---------- Toast Auto-Dismiss ---------- */
  function showToast(message, type) {
    var toast = document.getElementById('toast');
    if (!toast) {
      toast = document.createElement('div');
      toast.id = 'toast';
      toast.style.cssText =
        'position:fixed;bottom:24px;right:24px;z-index:9999;' +
        'padding:12px 20px;border-radius:8px;font-size:14px;' +
        'transition:all 0.6s cubic-bezier(0.16,1,0.3,1);' +
        'opacity:0;transform:translateY(12px);pointer-events:none;';
      document.body.appendChild(toast);
    }

    toast.textContent = message;
    toast.className = '';
    if (type === 'success') {
      toast.style.background = 'var(--color-success-bg)';
      toast.style.color = 'var(--color-success-text)';
      toast.style.border = '1px solid rgba(52,101,56,0.15)';
    } else if (type === 'error') {
      toast.style.background = 'var(--color-error-bg)';
      toast.style.color = 'var(--color-error-text)';
      toast.style.border = '1px solid rgba(159,47,45,0.15)';
    }

    requestAnimationFrame(function () {
      toast.style.opacity = '1';
      toast.style.transform = 'translateY(0)';
    });

    clearTimeout(toast._timeout);
    toast._timeout = setTimeout(function () {
      toast.style.opacity = '0';
      toast.style.transform = 'translateY(12px)';
    }, 3000);
  }

  /* Expose to global scope */
  window.showToast = showToast;
})();
