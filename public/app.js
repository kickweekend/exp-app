// Простая логика работы с API для перелистывания изображений и сохранения оценок.
// Файл подключается в layout и не использует сторонних JS-библиотек.

document.addEventListener("DOMContentLoaded", () => {
  const imageContainer = document.querySelector("[data-image-viewer]");
  if (!imageContainer) return;

  const themeId = imageContainer.dataset.themeId;
  const imagesEndpoint = imageContainer.dataset.imagesEndpoint;
  const evaluationEndpointTemplate = imageContainer.dataset.evaluationEndpointTemplate;

  let images = [];
  let currentIndex = 0;

  const imageTitleEl = document.querySelector("[data-image-title]");
  const imageTagEl = document.querySelector("[data-image-tag]");
  const prevBtn = document.querySelector("[data-prev-image]");
  const nextBtn = document.querySelector("[data-next-image]");
  const scoreInput = document.querySelector("[data-evaluation-score]");
  const commentInput = document.querySelector("[data-evaluation-comment]");
  const saveBtn = document.querySelector("[data-save-evaluation]");

  function renderImage() {
    if (!images.length) return;
    const img = images[currentIndex];
    imageTitleEl.textContent = img.title;
    imageTagEl.src = img.image_url;
    imageTagEl.alt = img.title;
  }

  function loadImages() {
    fetch(imagesEndpoint)
      .then((response) => response.json())
      .then((data) => {
        images = data.images || [];
        currentIndex = 0;
        renderImage();
      })
      .catch((error) => {
        console.error("Error loading images:", error);
      });
  }

  function changeImage(direction) {
    if (!images.length) return;
    currentIndex = (currentIndex + direction + images.length) % images.length;
    renderImage();
  }

  function saveEvaluation() {
    if (!images.length) return;
    const img = images[currentIndex];
    const endpoint = evaluationEndpointTemplate.replace(":image_id", img.id);

    fetch(endpoint, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({
        evaluation: {
          score: scoreInput.value,
          comment: commentInput.value,
        },
      }),
    })
      .then((response) => response.json())
      .then(() => {
        alert(imageContainer.dataset.savedMessage || "Оценка сохранена");
      })
      .catch((error) => {
        console.error("Error saving evaluation:", error);
      });
  }

  prevBtn?.addEventListener("click", () => changeImage(-1));
  nextBtn?.addEventListener("click", () => changeImage(1));
  saveBtn?.addEventListener("click", saveEvaluation);

  loadImages();
});

