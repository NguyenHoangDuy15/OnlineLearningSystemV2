<style>
    /* Styling for the chatbot icon */
    .chatbot-icon {
        position: fixed;
        bottom: 20px;
        right: 20px;
        background-color: #007bff;
        color: white;
        border-radius: 50%;
        width: 60px;
        height: 60px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        z-index: 1000;
        font-size: 24px;
        transition: transform 0.2s ease, background-color 0.3s ease;
    }
    .chatbot-icon:hover {
        transform: scale(1.1);
        background-color: #0056b3;
    }

    /* Styling for the chatbot window */
    .chatbot-window {
        position: fixed;
        bottom: 90px;
        right: 20px;
        width: 380px;
        height: 500px;
        background-color: #fff;
        display: none;
        flex-direction: column;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        border-radius: 15px;
        z-index: 1000;
        overflow: hidden;
        border: 1px solid #e0e0e0;
    }

    /* Styling for the window header */
    .chatbot-header {
        background-color: #007bff;
        color: white;
        padding: 12px 15px;
        font-size: 18px;
        font-weight: 600;
        text-align: center;
        position: relative;
        border-bottom: 1px solid #0056b3;
    }
    .chatbot-header .close-btn {
        position: absolute;
        right: 15px;
        top: 50%;
        transform: translateY(-50%);
        font-size: 20px;
        cursor: pointer;
        color: white;
        transition: color 0.3s ease;
    }
    .chatbot-header .close-btn:hover {
        color: #e0e0e0;
    }

    /* Styling for the chatbox */
    .chatbox {
        flex: 1;
        overflow-y: auto;
        padding: 20px;
        background-color: #f5f7fa;
        scrollbar-width: thin;
        scrollbar-color: #007bff #e9ecef;
    }
    .chatbox::-webkit-scrollbar {
        width: 8px;
    }
    .chatbox::-webkit-scrollbar-track {
        background: #e9ecef;
        border-radius: 10px;
    }
    .chatbox::-webkit-scrollbar-thumb {
        background-color: #007bff;
        border-radius: 10px;
    }

    /* Styling for messages */
    .message {
        margin: 12px 0;
        padding: 12px 18px;
        border-radius: 15px;
        max-width: 80%;
        line-height: 1.5;
        word-wrap: break-word;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        transition: transform 0.2s ease;
    }
    .message:hover {
        transform: translateY(-2px);
    }
    .user-message {
        text-align: right;
        color: white;
        background-color: #007bff;
        margin-left: auto;
        border-bottom-right-radius: 5px;
    }
    .bot-message {
        text-align: left;
        color: #333;
        background-color: #e9ecef;
        margin-right: auto;
        border-bottom-left-radius: 5px;
    }

    /* Styling for the input area */
    .input-area {
        padding: 15px;
        border-top: 1px solid #e0e0e0;
        display: flex;
        align-items: center;
        gap: 10px;
        background-color: #fff;
        box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.05);
    }
    .input-area form {
        display: flex;
        align-items: center;
        width: 100%;
        gap: 10px;
    }
    .input-area input[type="text"] {
        flex: 1;
        padding: 12px 15px;
        border: 1px solid #ddd;
        border-radius: 25px;
        outline: none;
        font-size: 14px;
        transition: border-color 0.3s ease, box-shadow 0.3s ease;
    }
    .input-area input[type="text"]:focus {
        border-color: #007bff;
        box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
    }
    .input-area input[type="submit"] {
        padding: 12px 25px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 500;
        transition: background-color 0.3s ease, transform 0.2s ease;
    }
    .input-area input[type="submit"]:hover {
        background-color: #0056b3;
        transform: translateY(-2px);
    }
</style>

<!-- Chatbot Icon -->
<div class="chatbot-icon" onclick="toggleChatbot()">?</div>

<!-- Chatbot Window -->
<div class="chatbot-window" id="chatbotWindow">
    <div class="chatbot-header">
        Chatbot
        <span class="close-btn" onclick="toggleChatbot()">×</span>
    </div>
    <div class="chatbox" id="chatbox">
        <div class="message bot-message">Chatbot: Hello! How can I assist you today?</div>
    </div>
    <div class="input-area">
        <form id="chatbotForm">
            <input type="text" name="message" id="messageInput" placeholder="Type your message..." required>
            <input type="submit" value="Send">
        </form>
    </div>
</div>

<script>
    // L?y context path t? JSP
    const contextPath = "${pageContext.request.contextPath}";

    // Function to toggle the chatbot window
    function toggleChatbot() {
        const chatbotWindow = document.getElementById("chatbotWindow");
        const isOpen = chatbotWindow.style.display === "flex";
        chatbotWindow.style.display = isOpen ? "none" : "flex";
        sessionStorage.setItem("chatbotOpen", !isOpen);
    }

    // Restore chatbot state on page load
    window.onload = function() {
        const chatbotWindow = document.getElementById("chatbotWindow");
        const isOpen = sessionStorage.getItem("chatbotOpen") === "true";
        if (isOpen) {
            chatbotWindow.style.display = "flex";
        }
        const chatbox = document.getElementById("chatbox");
        chatbox.scrollTop = chatbox.scrollHeight;
    };

    // Handle form submission with AJAX
    document.getElementById("chatbotForm").addEventListener("submit", function(event) {
        event.preventDefault();

        const messageInput = document.getElementById("messageInput");
        const userMessage = messageInput.value.trim();
        if (!userMessage) return;

        const chatbox = document.getElementById("chatbox");
        const userDiv = document.createElement("div");
        userDiv.className = "message user-message";
        userDiv.textContent = "You: " + userMessage;
        chatbox.appendChild(userDiv);

        chatbox.scrollTop = chatbox.scrollHeight;
        messageInput.value = "";

        // G?i yêu c?u AJAX ??n ChatbotServlet v?i context path
        fetch(contextPath + "/ChatbotServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: "message=" + encodeURIComponent(userMessage)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            const botDiv = document.createElement("div");
            botDiv.className = "message bot-message";
            botDiv.textContent = "Chatbot: " + data.botResponse;
            chatbox.appendChild(botDiv);
            chatbox.scrollTop = chatbox.scrollHeight;
        })
        .catch(error => {
            console.error("Error:", error);
            const botDiv = document.createElement("div");
            botDiv.className = "message bot-message";
            botDiv.textContent = "Chatbot: ?ã x?y ra l?i. Details: " + error.message;
            chatbox.appendChild(botDiv);
            chatbox.scrollTop = chatbox.scrollHeight;
        });
    });

    // G?i form khi nh?n Enter
    document.getElementById("messageInput").addEventListener("keypress", function(event) {
        if (event.key === "Enter") {
            event.preventDefault();
            document.getElementById("chatbotForm").dispatchEvent(new Event("submit"));
        }
    });

    // Close chatbot when clicking outside
    document.addEventListener("click", function(event) {
        const chatbotWindow = document.getElementById("chatbotWindow");
        const chatbotIcon = document.querySelector(".chatbot-icon");
        const chatbotForm = document.getElementById("chatbotForm");
        
        if (chatbotForm.contains(event.target)) {
            return;
        }

        if (!chatbotWindow.contains(event.target) && !chatbotIcon.contains(event.target)) {
            chatbotWindow.style.display = "none";
            sessionStorage.setItem("chatbotOpen", "false");
        }
    });
</script>