const questions = [
  {
    q: 'A developer hardcodes database credentials in source code that is stored in a public repository. Which mitigation best addresses this vulnerability?',
    options: ['Encrypt the database at rest', 'Store secrets in a vault and rotate credentials', 'Enable database replication', 'Add more web servers'],
    answer: 1,
    rationale: 'Hardcoded secrets risk immediate compromise when exposed. Centralize secrets in a vault, remove from code, and rotate them.',
    domain: 'Domain 2 – Threats/Vulnerabilities (credential exposure)',
  },
  {
    q: 'A public web server needs to accept internet traffic but connect to an internal database. Where should the database reside in a secure design?',
    options: ['On the same subnet as the web server', 'In the DMZ next to the web server', 'On an internal network segment with restricted ports', 'On a public cloud bucket'],
    answer: 2,
    rationale: 'Place databases on protected internal segments and only allow required ports from the DMZ; avoid exposing them directly.',
    domain: 'Domain 3 – Security Architecture (network segmentation)',
  },
  {
    q: 'Users report slow logons after MFA rollout. Leadership considers disabling MFA. What should the security team do FIRST?',
    options: ['Disable MFA temporarily', 'Collect metrics, optimize enrollment, and educate users', 'Switch to password-only authentication', 'Ignore the feedback'],
    answer: 1,
    rationale: 'Maintain MFA for security; improve user experience through training, faster push methods, and performance tuning before removing controls.',
    domain: 'Domain 1 – Controls and AAA',
  },
  {
    q: 'A SOC analyst sees beaconing to an unfamiliar domain from one workstation. What is the best immediate action?',
    options: ['Reimage all endpoints', 'Shut down the SIEM', 'Isolate the workstation from the network', 'Wait for another alert'],
    answer: 2,
    rationale: 'Contain first by isolating the host to stop potential spread, then investigate and eradicate.',
    domain: 'Domain 4 – Incident response containment',
  },
  {
    q: 'During procurement, which control most directly reduces risk of malicious code in third-party software?',
    options: ['Requiring code signing and validating signatures on updates', 'Using a warm site for recovery', 'Purchasing more bandwidth', 'Allowing shared vendor accounts'],
    answer: 0,
    rationale: 'Code signing with verification ensures software integrity from suppliers, reducing supply chain tampering.',
    domain: 'Domain 5 – Supply chain security',
  },
  {
    q: 'A mobile device policy enforces screen locks, full-disk encryption, and geofencing. Which Security+ concept is being applied?',
    options: ['Data minimization', 'Zero trust network access', 'Defense in depth for endpoint security', 'Certificate pinning'],
    answer: 2,
    rationale: 'Multiple layered controls on endpoints illustrate defense in depth to protect mobile data.',
    domain: 'Domain 1 – Control functions',
  },
  {
    q: 'Which option BEST prevents SQL injection in a web application?',
    options: ['Disable TLS 1.3', 'Use parameterized queries and input validation', 'Increase bandwidth', 'Add more logging only'],
    answer: 1,
    rationale: 'Parameterized queries (prepared statements) stop input from being executed as code; validation further reduces risk.',
    domain: 'Domain 2 – Application vulnerabilities',
  },
  {
    q: 'An organization wants context-aware access that factors device health and location before allowing logins. Which model fits best?',
    options: ['DAC', 'RBAC', 'ABAC with conditional access', 'MAC'],
    answer: 2,
    rationale: 'Attribute-based access control evaluates attributes like device compliance and location for dynamic decisions.',
    domain: 'Domain 3 – Identity architecture',
  },
  {
    q: 'Backups are taken nightly with a goal of losing no more than 4 hours of data. Which metric does this describe?',
    options: ['RTO', 'ALE', 'RPO', 'MTTR'],
    answer: 2,
    rationale: 'Recovery Point Objective (RPO) defines acceptable data loss in time.',
    domain: 'Domain 4 – BCP/DRP metrics',
  },
  {
    q: 'A phishing simulation shows high click rates in the finance team. What is the BEST next step?',
    options: ['Fire the users', 'Disable email attachments', 'Provide targeted training and track improvement', 'Ignore the results'],
    answer: 2,
    rationale: 'Targeted training with follow-up measurements addresses the human risk without disrupting business unnecessarily.',
    domain: 'Domain 5 – Awareness and training',
  },
  {
    q: 'A company must ensure logs cannot be altered after collection. Which solution best meets this requirement?',
    options: ['Send logs over HTTP to a server', 'Store logs on a local desktop', 'Forward logs to an immutable, access-controlled storage location', 'Delete logs monthly'],
    answer: 2,
    rationale: 'Immutable storage with access control preserves integrity and supports nonrepudiation.',
    domain: 'Domain 4 – Logging integrity',
  },
  {
    q: 'Which statement about tokenization is CORRECT?',
    options: ['It hashes data irreversibly', 'It replaces sensitive data with reversible placeholders stored separately', 'It compresses data to reduce size', 'It is only for network traffic'],
    answer: 1,
    rationale: 'Tokenization swaps sensitive values for tokens while storing the mapping securely elsewhere; tokens can be detokenized under control.',
    domain: 'Domain 3 – Data protection',
  },
];

let currentIndex = 0;
let shuffled = [];
let answered = false;

const questionEl = document.getElementById('question-text');
const optionsEl = document.getElementById('options');
const progressEl = document.getElementById('progress');
const feedbackEl = document.getElementById('feedback');
const submitBtn = document.getElementById('submit');
const nextBtn = document.getElementById('next');
const restartBtn = document.getElementById('restart');

function shuffle(arr) {
  const copy = [...arr];
  for (let i = copy.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  return copy;
}

function renderQuestion() {
  const q = shuffled[currentIndex];
  progressEl.textContent = `Question ${currentIndex + 1} of ${shuffled.length}`;
  questionEl.textContent = q.q;
  optionsEl.innerHTML = '';
  feedbackEl.textContent = '';
  answered = false;
  submitBtn.disabled = false;
  nextBtn.disabled = true;

  q.options.forEach((opt, idx) => {
    const label = document.createElement('label');
    label.className = 'option';

    const input = document.createElement('input');
    input.type = 'radio';
    input.name = 'answer';
    input.value = idx;

    const span = document.createElement('span');
    span.textContent = opt;

    input.addEventListener('change', () => {
      document.querySelectorAll('.option').forEach((el) => el.classList.remove('selected'));
      label.classList.add('selected');
    });

    label.appendChild(input);
    label.appendChild(span);
    optionsEl.appendChild(label);
  });
}

function handleSubmit() {
  if (answered) return;
  const selected = optionsEl.querySelector('input[name="answer"]:checked');
  if (!selected) {
    feedbackEl.textContent = 'Select an answer before submitting.';
    return;
  }

  const q = shuffled[currentIndex];
  const chosen = Number(selected.value);
  answered = true;

  document.querySelectorAll('.option').forEach((label, idx) => {
    if (idx === q.answer) label.classList.add('correct');
    if (idx === chosen && idx !== q.answer) label.classList.add('incorrect');
  });

  if (chosen === q.answer) {
    feedbackEl.textContent = `Correct – ${q.rationale} (${q.domain})`;
  } else {
    feedbackEl.textContent = `Incorrect – ${q.rationale} (${q.domain})`;
  }

  submitBtn.disabled = true;
  nextBtn.disabled = false;
}

function handleNext() {
  if (!answered) {
    feedbackEl.textContent = 'Submit an answer first.';
    return;
  }
  currentIndex += 1;
  if (currentIndex >= shuffled.length) {
    feedbackEl.textContent = 'Quiz complete! Reset to try again.';
    submitBtn.disabled = true;
    nextBtn.disabled = true;
    return;
  }
  renderQuestion();
}

function resetQuiz() {
  shuffled = shuffle(questions);
  currentIndex = 0;
  renderQuestion();
}

submitBtn.addEventListener('click', handleSubmit);
nextBtn.addEventListener('click', handleNext);
restartBtn.addEventListener('click', resetQuiz);

document.addEventListener('DOMContentLoaded', resetQuiz);
