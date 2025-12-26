const questionNumberEl = document.getElementById('question-number');
const questionTextEl = document.getElementById('question-text');
const optionsForm = document.getElementById('options-form');
const feedbackEl = document.getElementById('feedback');
const submitBtn = document.getElementById('submit-btn');
const nextBtn = document.getElementById('next-btn');
const resultsEl = document.getElementById('results');
const quizBodyEl = document.getElementById('quiz-body');
const scoreTextEl = document.getElementById('score-text');
const restartBtn = document.getElementById('restart-btn');

let shuffledQuestions = [];
let currentIndex = 0;
let score = 0;
let answered = false;

function shuffle(array) {
  const result = [...array];
  for (let i = result.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}

function renderQuestion() {
  const currentQuestion = shuffledQuestions[currentIndex];
  questionNumberEl.textContent = `Question ${currentIndex + 1} of ${shuffledQuestions.length}`;
  questionTextEl.textContent = currentQuestion.question;
  feedbackEl.textContent = '';
  optionsForm.innerHTML = '';
  answered = false;
  submitBtn.disabled = false;
  nextBtn.disabled = true;

  Object.entries(currentQuestion.options).forEach(([key, value]) => {
    const optionId = `option-${currentQuestion.id}-${key}`;
    const label = document.createElement('label');
    label.className = 'option';
    label.setAttribute('for', optionId);

    const input = document.createElement('input');
    input.type = 'radio';
    input.name = 'answer';
    input.value = key;
    input.id = optionId;

    input.addEventListener('change', () => {
      document.querySelectorAll('.option').forEach((opt) => opt.classList.remove('selected'));
      label.classList.add('selected');
    });

    const text = document.createElement('span');
    text.textContent = `${key}. ${value}`;

    label.appendChild(input);
    label.appendChild(text);
    optionsForm.appendChild(label);
  });
}

function getSelectedAnswer() {
  const checked = optionsForm.querySelector('input[name="answer"]:checked');
  return checked ? checked.value : null;
}

function lockOptions() {
  optionsForm.querySelectorAll('input[name="answer"]').forEach((input) => {
    input.disabled = true;
  });
}

function handleSubmit() {
  if (answered) return;
  const selected = getSelectedAnswer();
  if (!selected) {
    feedbackEl.textContent = 'Please select an answer before submitting.';
    return;
  }

  const currentQuestion = shuffledQuestions[currentIndex];
  const optionLabels = optionsForm.querySelectorAll('.option');

  optionLabels.forEach((label) => {
    const input = label.querySelector('input');
    if (input.value === currentQuestion.correctAnswer) {
      label.classList.add('correct');
    }
    if (input.checked && input.value !== currentQuestion.correctAnswer) {
      label.classList.add('incorrect');
    }
  });

  if (selected === currentQuestion.correctAnswer) {
    score += 1;
    feedbackEl.textContent = 'Correct!';
  } else {
    feedbackEl.textContent = `Incorrect. Correct answer: ${currentQuestion.correctAnswer}.`;
  }

  lockOptions();
  answered = true;
  submitBtn.disabled = true;
  nextBtn.disabled = false;
}

function showResults() {
  quizBodyEl.hidden = true;
  resultsEl.hidden = false;
  scoreTextEl.textContent = `You answered ${score} out of ${shuffledQuestions.length} questions correctly.`;
}

function handleNext() {
  if (!answered) {
    feedbackEl.textContent = 'Submit an answer before moving to the next question.';
    return;
  }
  currentIndex += 1;
  if (currentIndex >= shuffledQuestions.length) {
    showResults();
    return;
  }
  renderQuestion();
}

function restartQuiz() {
  shuffledQuestions = shuffle(questions);
  currentIndex = 0;
  score = 0;
  resultsEl.hidden = true;
  quizBodyEl.hidden = false;
  renderQuestion();
}

submitBtn.addEventListener('click', handleSubmit);
nextBtn.addEventListener('click', handleNext);
restartBtn.addEventListener('click', restartQuiz);

document.addEventListener('DOMContentLoaded', () => {
  shuffledQuestions = shuffle(questions);
  renderQuestion();
});
