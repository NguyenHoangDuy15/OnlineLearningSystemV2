<main class="main-content" id="mainContent">
    <div class="form-container">
        <h2><%= isEdit ? "Edit Lessons" : "Add Lessons" %></h2>
        <form action="LessonServlet" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="<%= isEdit ? "updateLesson" : "addLesson" %>">
            <input type="hidden" name="courseId" value="<%= courseId %>">
            
            <div id="lessons-container">
                <% if (isEdit && lesson != null) { %>
                <div class="lesson-item" data-lesson-id="<%= lesson.getLessonID() %>">
                    <input type="hidden" name="lessonId[]" value="<%= lesson.getLessonID() %>">
                    <div class="form-group">
                        <label for="title_0">Title</label>
                        <input type="text" id="title_0" name="title[]" value="<%= lesson.getTitle() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="content_0">Content (YouTube URL)</label>
                        <textarea id="content_0" name="content[]" required oninput="validateYouTubeUrl(this)"><%= lesson.getContent() %></textarea>
                        <div class="error-message" id="content-error_0">Content must be a valid YouTube URL</div>
                    </div>
                    <button type="button" class="btn btn-danger delete-lesson" style="display: none;" onclick="deleteLesson(this)">Delete</button>
                </div>
                <% } else { %>
                <div class="lesson-item">
                    <div class="form-group">
                        <label for="title_0">Title</label>
                        <input type="text" id="title_0" name="title[]" required>
                    </div>
                    <div class="form-group">
                        <label for="content_0">Content (YouTube URL)</label>
                        <textarea id="content_0" name="content[]" required oninput="validateYouTubeUrl(this)"></textarea>
                        <div class="error-message" id="content-error_0">Content must be a valid YouTube URL</div>
                    </div>
                    <button type="button" class="btn btn-danger delete-lesson" style="display: none;" onclick="deleteLesson(this)">Delete</button>
                </div>
                <% } %>
            </div>

            <button type="button" class="btn btn-success" onclick="addLesson()">+ Add More Lesson</button>

            <div class="button-group">
                <button type="submit" class="btn btn-primary">Save</button>
                <button type="button" class="btn btn-danger" onclick="window.location.href = 'CourseServlet?courseId=<%= courseId %>'">Cancel</button>
            </div>
        </form>
    </div>
</main>

<style>
    .lesson-item {
        border: 1px solid var(--border);
        padding: 15px;
        margin-bottom: 15px;
        border-radius: 4px;
        position: relative;
    }
    .btn-success {
        background: var(--gradient-success);
        margin-bottom: 15px;
    }
    .btn-success:hover {
        background: linear-gradient(90deg, #27AE60, #2ECC71);
        transform: translateY(-2px);
    }
    .delete-lesson {
        margin-top: 10px;
    }
</style>

<script>
    let lessonCount = <%= isEdit && lesson != null ? 1 : 1 %>;

    function addLesson() {
        const container = document.getElementById('lessons-container');
        const newLesson = document.createElement('div');
        newLesson.className = 'lesson-item';
        newLesson.innerHTML = `
            <div class="form-group">
                <label for="title_${lessonCount}">Title</label>
                <input type="text" id="title_${lessonCount}" name="title[]" required>
            </div>
            <div class="form-group">
                <label for="content_${lessonCount}">Content (YouTube URL)</label>
                <textarea id="content_${lessonCount}" name="content[]" required oninput="validateYouTubeUrl(this)"></textarea>
                <div class="error-message" id="content-error_${lessonCount}">Content must be a valid YouTube URL</div>
            </div>
            <button type="button" class="btn btn-danger delete-lesson" onclick="deleteLesson(this)">Delete</button>
        `;
        container.appendChild(newLesson);
        lessonCount++;
        updateDeleteButtons();
    }

    function deleteLesson(button) {
        button.parentElement.remove();
        lessonCount--;
        updateDeleteButtons();
    }

    function updateDeleteButtons() {
        const lessons = document.getElementsByClassName('lesson-item');
        const deleteButtons = document.getElementsByClassName('delete-lesson');
        for (let btn of deleteButtons) {
            btn.style.display = lessons.length > 1 ? 'block' : 'none';
        }
    }

    function validateYouTubeUrl(textarea) {
        const contentError = textarea.nextElementSibling;
        const youtubeUrlPattern = /^https:\/\/www\.youtube\.com\/watch\?v=[A-Za-z0-9_-]+/;
        
        if (!textarea.value.match(youtubeUrlPattern)) {
            contentError.style.display = 'block';
            return false;
        } else {
            contentError.style.display = 'none';
            return true;
        }
    }

    function validateForm() {
        const textareas = document.querySelectorAll('textarea[name="content[]"]');
        let isValid = true;
        
        textareas.forEach(textarea => {
            if (!validateYouTubeUrl(textarea)) {
                isValid = false;
            }
        });
        
        return isValid;
    }

    // Initial update of delete buttons
    document.addEventListener('DOMContentLoaded', updateDeleteButtons);
</script>