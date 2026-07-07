<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.User" %>
<%@ page import="com.travel.model.Destination" %>
<%@ page import="com.travel.service.DestinationService" %>
<%@ page import="java.util.List" %>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    DestinationService ds = new DestinationService();
    List<Destination> destinations = ds.getAll();
    List<String> regions = ds.getAllRegions();
    List<String> types = ds.getAllTypes();
%>
<%@ include file="../header.jsp" %>
<main>
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <h4 style="margin-bottom:var(--space-4);">Admin Panel</h4>
            <nav>
                <ul>
                    <li><a href="dashboard.jsp">Dashboard</a></li>
                    <li><a href="destination_manage.jsp" class="active">Destinations</a></li>
                    <li><a href="user_manage.jsp">Users</a></li>
                </ul>
            </nav>
        </aside>

        <div class="admin-main">
            <div class="flex items-center justify-between mb-8">
                <div class="section-header" style="margin-bottom:0;">
                    <h2>Destinations (<%= destinations.size() %>)</h2>
                </div>
                <button class="btn btn-primary" onclick="document.getElementById('add-form').classList.toggle('hidden')">
                    + Add New
                </button>
            </div>

            <!-- Add Form -->
            <div id="add-form" class="card hidden" style="margin-bottom:var(--space-8);">
                <div class="card-body" style="padding:var(--space-8);">
                    <h4 style="margin-bottom:var(--space-6);">Add New Destination</h4>
                    <form action="<%=contextPath%>/admin/destination/" method="post">
                        <input type="hidden" name="action" value="create">
                        <div class="grid-2">
                            <div class="form-group">
                                <label class="form-label" for="name">Name</label>
                                <input type="text" id="name" name="name" class="form-input" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="region">Region</label>
                                <select id="region" name="region" class="form-input" required>
                                    <option value="">Select...</option>
                                    <% for (String r : regions) { %>
                                        <option value="<%= r %>"><%= r %></option>
                                    <% } %>
                                    <option value="华东">华东</option><option value="华北">华北</option>
                                    <option value="华南">华南</option><option value="西南">西南</option>
                                    <option value="西北">西北</option><option value="华中">华中</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="type">Type</label>
                                <select id="type" name="type" class="form-input" required>
                                    <option value="">Select...</option>
                                    <% for (String t : types) { %>
                                        <option value="<%= t %>"><%= t %></option>
                                    <% } %>
                                    <option value="自然风光">自然风光</option><option value="历史古迹">历史古迹</option>
                                    <option value="海岛度假">海岛度假</option><option value="城市观光">城市观光</option>
                                    <option value="美食之旅">美食之旅</option><option value="探险户外">探险户外</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="ticketPrice">Ticket Price (0 = Free)</label>
                                <input type="number" id="ticketPrice" name="ticketPrice" class="form-input" value="0" step="0.01" min="0">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Cover Image</label>
                            <div class="image-upload-area" style="display:flex;align-items:flex-start;gap:var(--space-4);flex-wrap:wrap;">
                                <div>
                                    <div style="margin-bottom:var(--space-2);font-size:var(--text-xs);color:var(--color-text-tertiary);">Upload from device</div>
                                    <label class="btn btn-outline btn-sm" style="cursor:pointer;margin-bottom:var(--space-1);">
                                        Choose File
                                        <input type="file" accept="image/*" style="display:none;"
                                               onchange="handleFileSelect(this,'add-image-preview','add-image-url')">
                                    </label>
                                    <div class="form-hint">JPG/PNG/GIF/WebP, max 5MB</div>
                                </div>
                                <div style="flex:1;min-width:200px;">
                                    <div style="margin-bottom:var(--space-2);font-size:var(--text-xs);color:var(--color-text-tertiary);">Or paste image URL</div>
                                    <input type="text" id="add-image-url" name="image" class="form-input"
                                           placeholder="https://picsum.photos/seed/name/800/600"
                                           oninput="updatePreview(this.value,'add-image-preview')">
                                </div>
                                <div id="add-image-preview" style="width:120px;height:80px;border:1px solid var(--color-border);border-radius:var(--radius-md);background:var(--color-surface-hover);display:flex;align-items:center;justify-content:center;overflow:hidden;flex-shrink:0;">
                                    <span style="font-size:var(--text-xs);color:var(--color-text-tertiary);">Preview</span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="description">Description</label>
                            <textarea id="description" name="description" class="form-input" required></textarea>
                        </div>
                        <div class="grid-2">
                            <div class="form-group">
                                <label class="form-label" for="address">Address</label>
                                <input type="text" id="address" name="address" class="form-input">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="openTime">Open Hours</label>
                                <input type="text" id="openTime" name="openTime" class="form-input" placeholder="e.g. 08:00-17:00">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary">Add Destination</button>
                    </form>
                </div>
            </div>

            <!-- Destination Table -->
            <div style="overflow-x:auto;">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Region</th>
                            <th>Type</th>
                            <th>Price</th>
                            <th>Rating</th>
                            <th>Votes</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Destination d : destinations) { %>
                        <tr>
                            <td><%= d.getId() %></td>
                            <td><strong><%= d.getName() %></strong></td>
                            <td><span class="tag tag-blue"><%= d.getRegion() %></span></td>
                            <td><span class="tag tag-green"><%= d.getType() %></span></td>
                            <td><%= d.getTicketPriceDisplay() %></td>
                            <td><%= String.format("%.1f", d.getRating()) %></td>
                            <td><%= d.getVoteCount() %></td>
                            <td>
                                <div class="flex gap-2">
                                    <!-- Edit button (shortened: opens inline) -->
                                    <button class="btn btn-outline btn-sm"
                                            onclick="var row=this.closest('tr');var next=row.nextElementSibling;if(next&&next.classList.contains('edit-row')){next.remove()}else{showEdit(row,<%= d.getId() %>,'<%= d.getName() %>','<%= d.getRegion() %>','<%= d.getType() %>','<%= d.getImage() != null ? d.getImage() : "" %>','<%= d.getDescription() != null ? d.getDescription().replace("'","\\'") : "" %>','<%= d.getAddress() != null ? d.getAddress() : "" %>','<%= d.getOpenTime() != null ? d.getOpenTime() : "" %>','<%= d.getTicketPrice() %>')}">
                                        Edit
                                    </button>
                                    <a href="<%=contextPath%>/admin/destination/?action=delete&id=<%=d.getId()%>"
                                       class="btn btn-outline btn-sm" data-confirm="Delete <%= d.getName() %>?" style="color:var(--color-error-text);border-color:var(--color-error-text);">Delete</a>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<script>
function showEdit(row, id, name, region, type, image, description, address, openTime, price) {
    var editRow = document.createElement('tr');
    editRow.classList.add('edit-row');
    editRow.innerHTML = '<td colspan="8" style="padding:var(--space-6);background:var(--color-surface-hover);">'
        + '<h4 style="margin-bottom:var(--space-4);">Edit: ' + name + '</h4>'
        + '<form action="<%=contextPath%>/admin/destination/" method="post">'
        + '<input type="hidden" name="action" value="update">'
        + '<input type="hidden" name="id" value="' + id + '">'
        + '<div class="grid-2">'
        + '<div class="form-group"><label class="form-label">Name</label><input type="text" name="name" class="form-input" value="' + escapeHtml(name) + '" required></div>'
        + '<div class="form-group"><label class="form-label">Region</label><input type="text" name="region" class="form-input" value="' + escapeHtml(region) + '" required></div>'
        + '<div class="form-group"><label class="form-label">Type</label><input type="text" name="type" class="form-input" value="' + escapeHtml(type) + '" required></div>'
        + '<div class="form-group"><label class="form-label">Price</label><input type="number" name="ticketPrice" class="form-input" value="' + price + '" step="0.01" min="0"></div>'
        + '</div>'
        + '<div class="form-group"><label class="form-label">Image</label>'
        + '<div style="display:flex;align-items:flex-end;gap:8px;flex-wrap:wrap;">'
        + '<input type="text" name="image" id="edit-image-' + id + '" class="form-input" style="flex:1;min-width:200px;" value="' + escapeHtml(image) + '" placeholder="Image URL">'
        + '<label class="btn btn-outline btn-sm" style="cursor:pointer;white-space:nowrap;">Upload <input type="file" accept="image/*" style="display:none;" onchange="handleFileSelect(this,\'edit-preview-' + id + '\',\'edit-image-' + id + '\')"></label>'
        + '<div id="edit-preview-' + id + '" style="width:60px;height:40px;border:1px solid var(--color-border);border-radius:4px;overflow:hidden;flex-shrink:0;' + (image ? 'background-image:url(' + image + ');background-size:cover;' : '') + '"></div>'
        + '</div></div>'
        + '<div class="form-group"><label class="form-label">Description</label><textarea name="description" class="form-input">' + escapeHtml(description) + '</textarea></div>'
        + '<div class="grid-2">'
        + '<div class="form-group"><label class="form-label">Address</label><input type="text" name="address" class="form-input" value="' + escapeHtml(address) + '"></div>'
        + '<div class="form-group"><label class="form-label">Open Hours</label><input type="text" name="openTime" class="form-input" value="' + escapeHtml(openTime) + '"></div>'
        + '</div>'
        + '<button type="submit" class="btn btn-primary">Save Changes</button> '
        + '<button type="button" class="btn btn-outline btn-sm" onclick="this.closest(\'.edit-row\').remove()">Cancel</button>'
        + '</form></td>';
    row.parentNode.insertBefore(editRow, row.nextSibling);
}
function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');
}

/* Handle file selection - upload to server and fill in URL */
function handleFileSelect(fileInput, previewId, urlInputId) {
    var file = fileInput.files[0];
    if (!file) return;

    // Show preview immediately from local file
    var reader = new FileReader();
    reader.onload = function(e) {
        var preview = document.getElementById(previewId);
        if (preview) {
            preview.style.backgroundImage = 'url(' + e.target.result + ')';
            preview.style.backgroundSize = 'cover';
            preview.innerHTML = '<div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:rgba(0,0,0,0.3);"><span style="color:#fff;font-size:10px;">Uploading...</span></div>';
        }
    };
    reader.readAsDataURL(file);

    // Upload to server
    var formData = new FormData();
    formData.append('image', file);

    fetch('<%=contextPath%>/admin/upload-image', {
        method: 'POST',
        body: formData
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        var preview = document.getElementById(previewId);
        if (data.success) {
            document.getElementById(urlInputId).value = data.url;
            if (preview) {
                preview.style.backgroundImage = 'url(' + data.url + ')';
                preview.style.backgroundSize = 'cover';
                preview.innerHTML = '';
            }
            if (window.showToast) window.showToast('Image uploaded!', 'success');
        } else {
            if (preview) { preview.style.backgroundImage = ''; preview.innerHTML = '<span style="font-size:10px;color:var(--color-error-text);">Error</span>'; }
            alert('Upload failed: ' + (data.error || 'Unknown error'));
        }
    })
    .catch(function(err) {
        var preview = document.getElementById(previewId);
        if (preview) { preview.style.backgroundImage = ''; preview.innerHTML = '<span style="font-size:10px;color:var(--color-error-text);">Error</span>'; }
        alert('Upload error: ' + err.message);
    });
}

/* Live preview when URL is typed/pasted */
function updatePreview(url, previewId) {
    var preview = document.getElementById(previewId);
    if (preview && url) {
        preview.style.backgroundImage = 'url(' + url + ')';
        preview.style.backgroundSize = 'cover';
        preview.innerHTML = '';
    } else if (preview) {
        preview.style.backgroundImage = '';
        preview.innerHTML = '<span style="font-size:var(--text-xs);color:var(--color-text-tertiary);">Preview</span>';
    }
}
</script>
<%@ include file="../footer.jsp" %>
