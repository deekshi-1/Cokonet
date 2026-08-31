const hostname = window.location.hostname;
const API_URL = `http://${hostname}:3000`;

const messageInput = document.getElementById("messageInput");
const submitBtn = document.getElementById("submitBtn");
const fetchBtn = document.getElementById("fetchBtn");
const resultsContainer = document.getElementById("resultsContainer");
const totalRecords = document.getElementById("totalRecords");

const toast = document.getElementById("toast");
const toastMessage = document.getElementById("toastMessage");
const toastIcon = document.getElementById("toastIcon");


/* =========================
   SUBMIT DATA
========================= */

submitBtn.addEventListener("click", submitData);

messageInput.addEventListener("keydown", (event) => {

    if (event.key === "Enter") {
        submitData();
    }

});


async function submitData() {

    const content = messageInput.value.trim();

    if (!content) {

        showToast(
            "Please enter some data first.",
            "⚠️",
            "#f59e0b"
        );

        messageInput.focus();

        return;
    }


    setLoading(submitBtn, true);


    try {

        const response = await fetch(`${API_URL}/data`, {

            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({
                content
            })

        });


        if (!response.ok) {
            throw new Error("Failed to save data");
        }


        messageInput.value = "";

        showToast(
            "Data successfully pushed to MySQL!",
            "✓",
            "#34d399"
        );


        fetchData();


    } catch (error) {

        console.error(error);

        showToast(
            "Backend connection failed.",
            "✕",
            "#fb7185"
        );

    } finally {

        setLoading(submitBtn, false);

    }

}


/* =========================
   FETCH DATA
========================= */

fetchBtn.addEventListener("click", fetchData);


async function fetchData() {

    fetchBtn.classList.add("loading");

    resultsContainer.innerHTML = `
        <div class="empty-state">
            <div class="empty-icon">⏳</div>
            <h3>Connecting...</h3>
            <p>Retrieving data from the backend.</p>
        </div>
    `;


    try {

        const response = await fetch(`${API_URL}/data`);


        if (!response.ok) {
            throw new Error("Failed to fetch data");
        }


        const data = await response.json();


        totalRecords.textContent = data.length;


        if (data.length === 0) {

            resultsContainer.innerHTML = `

                <div class="empty-state">

                    <div class="empty-icon">🗂️</div>

                    <h3>Database is empty</h3>

                    <p>
                        Start by pushing your first data entry.
                    </p>

                </div>

            `;

            return;
        }


        resultsContainer.innerHTML = data
            .map((item, index) => {

                return `

                    <article
                        class="data-item"
                        style="
                            animation-delay:
                            ${index * 0.05}s
                        "
                    >

                        <div class="data-number">
                            #${item.id}
                        </div>


                        <div class="data-body">

                            <div class="data-content">
                                ${escapeHTML(item.content)}
                            </div>

                            <div class="data-meta">
                                Database Record
                            </div>

                        </div>

                    </article>

                `;

            })
            .join("");


    } catch (error) {

        console.error(error);


        resultsContainer.innerHTML = `

            <div class="empty-state">

                <div class="empty-icon">⚠️</div>

                <h3>Connection Failed</h3>

                <p>
                    Could not connect to the backend server.
                </p>

            </div>

        `;


        totalRecords.textContent = "—";


    } finally {

        fetchBtn.classList.remove("loading");

    }

}


/* =========================
   TOAST
========================= */

function showToast(message, icon, color) {

    toastMessage.textContent = message;

    toastIcon.textContent = icon;

    toast.style.borderColor = color;

    toast.classList.add("show");


    setTimeout(() => {

        toast.classList.remove("show");

    }, 3000);

}


/* =========================
   BUTTON LOADING
========================= */

function setLoading(button, isLoading) {

    if (isLoading) {

        button.classList.add("loading");

        button.disabled = true;

    } else {

        button.classList.remove("loading");

        button.disabled = false;

    }

}


/* =========================
   SECURITY
========================= */

function escapeHTML(str) {

    const div = document.createElement("div");

    div.textContent = str;

    return div.innerHTML;

}


/* =========================
   OPTIONAL AUTO LOAD
========================= */

// Uncomment this if you want
// the data to load automatically
// when the page opens.

fetchData();