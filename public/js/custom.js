window.onload = () => {
  observeHeaders();
};

function observeHeaders() {
  const observer = createObserver();
  const headers = document.querySelectorAll('h2[id]');
  headers.forEach((header) => observer.observe(header));
}

function createObserver() {
  return new IntersectionObserver(
    (entries) => {
      entries.forEach(({ target, isIntersecting }) => {
        if (isIntersecting) {
          const tableOfContents = document.getElementById('TableOfContents');
          const anchors = [...tableOfContents.querySelectorAll('a')];
          anchors.forEach((a) => a.parentElement.classList.remove('active'));

          const id = target.getAttribute('id');
          const link = tableOfContents.querySelector(`a[href="#${id}"]`);
          link.parentElement.classList.add('active');
        }
      });
    },
    { rootMargin: '0px 0px -88% 0px', threshold: 0 }
  );
}


