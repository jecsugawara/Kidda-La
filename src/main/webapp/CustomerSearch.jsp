<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="Error.jsp" %>
<%@ page import="model.Customer"%>
<%@ page import="java.util.ArrayList"%>
<%
	@SuppressWarnings("unchecked")
	String[][] customerData
		= (String[][]) session.getAttribute("customerData");
	String errorMsg = (String)request.getAttribute("errorMsg");
	if(request.getParameter("tel") != null) {
		session.setAttribute("tel", request.getParameter("tel"));
	}
	if(request.getParameter("name") != null) {
		session.setAttribute("name", request.getParameter("name"));
	}
%>
<!DOCTYPE html>
<html lang="ja" class="overflow-y-scroll">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>《顧客情報検索》 KIDDA-LA 業務システム</title>
	<link rel="icon" href="css/favicon.ico">
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/KIDDA-LA.css">
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<script type="text/javascript">
	function checkSearchSubmit() {
		if(document.getElementById('tel').value != ""
			|| document.getElementById('name').value != "") {
			return true;
		} else {
			showModalConfirm("【エラー】", 
				"電話番号と氏名カナのいずれか、<br>または両方を入力してください。",
				"error");
			return false;
		}
	}

	function inputReset(){
		document.getElementById('tel').value = "";
		document.getElementById('name').value = "";
		document.getElementById('searchResult').innerHTML = "";
	}

	function showModalConfirm(title, message, kind) {
		modal = new bootstrap.Modal(document.getElementById('modalConfirm'));
		if(kind == "error") {
			image = "css/Error.png";
			bgColor = "modal-header bg-danger-subtle";
		} else if(kind == "warning") {
			image = "css/Warning.png";
			bgColor = "modal-header bg-warning-subtle";
		} else {
			image = "css/Info.png";
			bgColor = "modal-header bg-success-subtle";
		}
		document.getElementById('modalConfirm_header').setAttribute('class', bgColor);
		document.getElementById('modalConfirm_image').src = image;
		document.getElementById('modalConfirm_title').innerHTML = title;
		document.getElementById('modalConfirm_message').innerHTML = message;
		modal.show();
		document.getElementById('body').style.paddingRight = '0px';
		document.getElementById('footer').style.paddingRight = '0px';
        document.getElementById('modalConfirm').style.paddingRight = '0px';
	}

	function adjustFooter() {
		clientHeight = document.documentElement.clientHeight;
		offsetHeight = document.documentElement.offsetHeight;
		if(clientHeight > offsetHeight) {
			document.getElementById('footer').removeAttribute('class', 'mt-auto');
			document.getElementById('footer').setAttribute('class', 'fixed-bottom');
		} else {
			document.getElementById('footer').removeAttribute('class', 'fixed-bottom');
			document.getElementById('footer').setAttribute('class', 'mt-auto');
		}
	}

	window.onload = function(){
		adjustFooter();
		<% if(errorMsg != null) { %>
		showModalConfirm("【確認】", "${errorMsg}", "warning");
		<% } %>
	};

	window.onpageshow = function(){
		//adjustFooter();
	};

	window.onresize = function(){
		//adjustFooter();
	};
	</script>
</head>

<body class="d-flex h-100 text-center text-dark" id="body">
	<div class="d-flex w-100 mx-auto flex-column">
		<header class="mb-5">
			<p class="fs-1 mt-2 mb-1">KIDDA-LA 業務システム</p>
			<p class="fs-3 mt-1 mb-2">《顧客情報検索》</p>
		</header>

		<main class="container">
		<div class="row">
			<div class="col-4 d-flex flex-column">
				<div class="card mb-3">
					<div class="card-header fs-5 bg-info">電話番号（ハイフンなし）
					</div>
					<div class="card-body bg-info-subtle">
						<input class="form-control fs-5" type="text" form="fm" 
							name="tel" id="tel" value="${tel}" 
							placeholder="例：09012345678">
					</div>
				</div>
				<div class="card mb-3">
					<div class="card-header fs-5 bg-info">氏名カナ（全角カタカナ）
					</div>
					<div class="card-body bg-info-subtle">
						<input class="form-control fs-5" type="text" form="fm" 
							name="name" id="name" value="${name}" 
							placeholder="例：ヤマダタロウ">
					</div>
				</div>
				<div class="row mb-3">
					<div class="col">
						<button class="btn w-100 btn-info btn-lg rounded-pill fs-5" 
							type="submit" form="fm">検索</button>
					</div>
				</div>
				<div class="container p-0">
					<div class="row">
						<div class="col">
							<button
								class="btn btn-secondary w-100 btn-lg rounded-pill fs-5" 
								type="button" onClick="inputReset();">入力消去</button>
						</div>
						<div class="col">
							<button 
								class="btn btn-secondary w-100 btn-lg rounded-pill fs-5" 
								type="button" onClick="location.href='MainMenu.jsp'">
								戻る</button>
						</div>
					</div>
				</div>
			</div>

			<div class="col-8" id="searchResult">
			<% if (customerData != null) { %>
				<div class="card mb-3">
					<div class="card-header fs-5 bg-warning">検索結果</div>
					<div class="card-body pb-2 bg-warning-subtle">
					<table class="table table-bordered fs-5 mb-2">
						<thead class="table-warning">
							<tr>
								<th>ID</th>
								<th>氏名</th>
								<th>カナ</th>
								<th>住所</th>
							</tr>
						</thead>
						<tbody>
						<% for(String[] customer : customerData) { %>
							<tr>
								<td class="bg-warning-subtle text-end">
									<%= customer[0] %></td>
								<td class="p-0 text-start align-middle">
									<a class="d-block text-decoration-none p-2" 
										href="KiddaLaController?custId=<%= customer[0] %>&command=OrderInputDisplay">
										<%= customer[1] %></a></td>
								<td class="p-0 text-start align-middle">
									<a class="d-block text-decoration-none p-2" 
										href="KiddaLaController?custId=<%= customer[0] %>&command=OrderInputDisplay">
										<%= customer[2] %></a></td>
								<td class="p-0 text-start align-middle">
									<a class="d-block text-decoration-none p-2" 
										href="KiddaLaController?custId=<%= customer[0] %>&command=OrderInputDisplay">
										<%= customer[3] %></a></td>
							</tr>
						<% } %>
						</tbody>
					</table>
					</div>
				</div>
			<% } %>
			</div>
		</div>
		</main>

		<footer class="mt-auto" id="footer">
			<p>&copy;Infotech Serve Inc.</p>
		</footer>
	</div>
	<form action="KiddaLaController" method="post" id="fm" onSubmit="return checkSearchSubmit()">
		<input type="hidden" name="command" value="CustomerSearch">
	</form>

	<div class="modal fade" id="modalConfirm" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header" id="modalConfirm_header">
					<div class="d-inline-flex">
		                <img src="" width="48px" height="48px" id="modalConfirm_image" alt="画像">
						<p class="modal-title fs-2" id="modalConfirm_title"></p>
					</div>
				</div>
				<div class="modal-body fs-5" id="modalConfirm_message"></div>
				<div class="modal-footer justify-content-center">
					<div class="d-flex flex-column w-100">
						<div class="row justify-content-center">
							<div class="col-6">
								<button type="button" class="btn btn-secondary text-white rounded-pill fs-5 w-100" data-bs-dismiss="modal">戻る</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>