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
  const imageAverageEl = document.querySelector("[data-image-average]");
  const imageUserScoreEl = document.querySelector("[data-image-user-score]");
  const prevBtn = document.querySelector("[data-prev-image]");
  const nextBtn = document.querySelector("[data-next-image]");
  const scoreInput = document.querySelector("[data-evaluation-score]");
  const commentInput = document.querySelector("[data-evaluation-comment]");
  const saveBtn = document.querySelector("[data-save-evaluation]");
  const commentsListEl = document.querySelector("[data-comments-list]");
  const commentsEmptyEl = document.querySelector("[data-comments-empty-msg]");

  function renderComments(img) {
    if (!commentsListEl || !commentsEmptyEl) return;
    commentsListEl.replaceChildren();
    const items = img.comments || [];
    if (!items.length) {
      commentsEmptyEl.hidden = false;
      return;
    }
    commentsEmptyEl.hidden = true;
    items.forEach((c) => {
      const row = document.createElement("article");
      row.className = "comment-bubble";
      const head = document.createElement("div");
      head.className = "comment-bubble__head";
      const name = document.createElement("span");
      name.className = "comment-bubble__name";
      name.textContent = c.user_name;
      const score = document.createElement("span");
      score.className = "comment-bubble__score";
      score.textContent = "★ " + c.score;
      head.append(name, score);
      const body = document.createElement("p");
      body.className = "comment-bubble__text";
      body.textContent = c.comment;
      row.append(head, body);
      commentsListEl.appendChild(row);
    });
  }

  function renderImage() {
    if (!images.length) return;
    const img = images[currentIndex];
    imageTitleEl.textContent = img.title;
    imageTagEl.src = img.image_url;
    imageTagEl.alt = img.title;

    if (imageAverageEl) {
      imageAverageEl.textContent = img.average_score
        ? img.average_score.toFixed(1)
        : imageAverageEl.dataset.empty;
    }

    if (imageUserScoreEl) {
      imageUserScoreEl.textContent = img.user_score || imageUserScoreEl.dataset.empty;
    }

    // Слайдер оценки: подставляем сохранённую оценку или значение по умолчанию.
    if (scoreInput) {
      const v = img.user_score != null ? String(img.user_score) : "3";
      scoreInput.value = v;
      scoreInput.setAttribute("aria-valuenow", v);
    }

    if (commentInput) {
      commentInput.value = img.user_comment != null ? img.user_comment : "";
    }

    renderComments(img);
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
    if (!images.length || !scoreInput) return;
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
          score: parseInt(scoreInput.value, 10),
          comment: commentInput.value,
        },
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        if (imageAverageEl && typeof data.average_score === "number") {
          imageAverageEl.textContent = data.average_score.toFixed(1);
        }

        if (imageUserScoreEl && typeof data.user_score === "number") {
          imageUserScoreEl.textContent = data.user_score;
        }

        const img = images[currentIndex];
        if (typeof data.user_comment === "string") {
          img.user_comment = data.user_comment;
        }
        if (Array.isArray(data.comments)) {
          img.comments = data.comments;
        }
        renderComments(img);

        alert(imageContainer.dataset.savedMessage || "Оценка сохранена");
      })
      .catch((error) => {
        console.error("Error saving evaluation:", error);
      });
  }

  scoreInput?.addEventListener("input", () => {
    scoreInput.setAttribute("aria-valuenow", scoreInput.value);
  });

  prevBtn?.addEventListener("click", () => changeImage(-1));
  nextBtn?.addEventListener("click", () => changeImage(1));
  saveBtn?.addEventListener("click", saveEvaluation);

  loadImages();
});

