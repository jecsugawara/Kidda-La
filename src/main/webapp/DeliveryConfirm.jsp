<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="Error.jsp" %>
<%@ page import="model.Customer"%>
<%@ page import="model.Item"%>
<%@ page import="model.OrderDetail"%>
<%@ page import="model.Tax"%>
<%@ page import="java.util.ArrayList"%>
<%
	Customer customer = (Customer) session.getAttribute("customer");
	@SuppressWarnings("unchecked")
	ArrayList<OrderDetail> orderDetailList = (ArrayList<OrderDetail>) request.getAttribute("orderDetailList");
	if(orderDetailList == null)	{
		orderDetailList = new ArrayList<OrderDetail>();
	}
	String msgFlag = (String)request.getAttribute("msgFlag");
	String orderDate = "";
	String status = "";
	if(msgFlag != null && (msgFlag.equals("registered") || msgFlag.equals("confirm"))) {
		int lastIdx = orderDetailList.size() - 1;
		OrderDetail orderDetailTop = orderDetailList.get(lastIdx);
		orderDate = orderDetailTop.getOrderDate();
	} else if(msgFlag != null && msgFlag.equals("completed")) {
		status = "disabled";
	}
%>
<!DOCTYPE html>
<html lang="ja" class="overflow-y-scroll">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>《配達情報》 KIDDA-LA 業務システム</title>
	<link rel="icon" href="css/favicon.ico">
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/KIDDA-LA.css">
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<script type="text/javascript">
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

	function showModalDeliConfirm() {
		modal = new bootstrap.Modal(document.getElementById('modalDeliConfirm'));
		modal.show();
		document.getElementById('body').style.paddingRight = '0px';
		document.getElementById('footer').style.paddingRight = '0px';
        document.getElementById('modalDeliConfirm').style.paddingRight = '0px';
	}

	function checkDeliSubmit() {
		showModalDeliConfirm();
		return false;
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

	window.onload = function() {
		adjustFooter();
		<% if(msgFlag != null && msgFlag.equals("registered")) { %>
		showModalConfirm("【注文情報登録完了】", "注文情報を登録しました。", "info");
		<% } else if(msgFlag != null && msgFlag.equals("completed")) { %>
		showModalConfirm("【配達完了】", "配達を完了しました。お疲れ様でした。", "info");
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
			<p class="fs-1 mt-2 mb-1 for-display">KIDDA-LA 業務システム</p>
			<p class="fs-3 mt-1 mb-2 for-display">《配達情報》</p>
			<p class="fs-1 mt-2 mb-1 for-print">キダーラ・ピザ</p>
			<p class="fs-3 mt-1 mb-2 for-print">《領収書》</p>
		</header>

		<main class="container">
		<div class="row">
			<div class="offset-1 col-10 d-flex flex-column">
				<div class="card mb-3">
					<div class="card-header fs-5 bg-warning">お客様情報</div>
					<div class="card-body bg-warning-subtle text-start">
						<div class="row mb-1">
							<label for="custId" class="col-2 col-form-label fs-5">ID</label>
							<div class="col-10">
								<input class="form-control-plaintext fs-5" type="text" placeholder="" value="<%=customer.getCustId()%>">
							</div>
						</div>
						<div class="row mb-1">
							<label for="custName" class="col-2 col-form-label fs-5">氏名</label>
							<div class="col-10">
								<input class="form-control-plaintext fs-5" type="text" placeholder="" value="<%=customer.getCustName()%> 様">
							</div>
						</div>
						<div class="row mb-1">
							<label for="kana" class="col-2 col-form-label fs-5">氏名カナ</label>
							<div class="col-10">
								<input class="form-control-plaintext fs-5" type="text" placeholder="" value="<%=customer.getKana()%> サマ">
							</div>
						</div>
						<div class="row mb-1">
							<label for="tel" class="col-2 col-form-label fs-5">電話番号</label>
							<div class="col-10">
								<input class="form-control-plaintext fs-5" type="text" placeholder="" value="<%=customer.getTel()%>" required>
							</div>
						</div>
						<div class="row mb-1">
							<label for="address" class="col-2 col-form-label fs-5">住所</label>
							<div class="col-10">
								<input class="form-control-plaintext fs-5" type="text" placeholder="" value="<%=customer.getAddress()%>">
							</div>
						</div>
						<% if(!orderDate.isEmpty()) { %>
						<div class="row mb-1">
							<label for="address" class="col-2 col-form-label fs-5">日付</label>
							<div class="col-10">
								<input class="form-control-plaintext fs-5" type="text" placeholder="" value="<%=orderDate%>">
							</div>
						</div>
						<% } %>
					</div>
				</div>

				<div class="card mb-3">
					<div class="card-header fs-5 bg-primary text-white">ご注文内容</div>
					<div class="card-body bg-primary-subtle">
					<% if(msgFlag != null && (msgFlag.equals("registered") || msgFlag.equals("confirm"))) { %>
					<table class="table table-bordered fs-5 mb-0">
						<thead class="table-primary">
							<tr>
								<th>NO</th>
								<th>ID</th>
								<th>商品名</th>
								<th>サイズ</th>
								<th>数量</th>
								<th>単価（円）</th>
								<th>小計（円）</th>
							</tr>
						</thead>
						<tbody>
							<%
							int allPrice = 0;
							for(OrderDetail orderDetail : orderDetailList) {
					           	Item item = orderDetail.getItem();
					           	Tax tax = orderDetail.getTax();
					           	int inTax = (int)Math.floor(item.getPrice() * (tax.getRate() + 1));
								int sumPrice = inTax * orderDetail.getQuantity();
							%>
							<tr>
								<td class="text-end"><%= orderDetail.getNo() %></td>
								<td class="text-center"><%= item.getItemId() %></td>
								<td class="text-start"><%= item.getItemName() %></td>
								<td class="text-center"><%= item.getSize() != null ? item.getSize() : "" %></td>
								<td class="text-end"><%= orderDetail.getQuantity() %></td>
								<td class="text-end"><%= String.format("%,d", inTax) %></td>
								<td class="text-end"><%= String.format("%,d", sumPrice) %></td>
							</tr>
							<%
								allPrice = allPrice + sumPrice;
							}
							%>
						</tbody>
					</table>
					<div class="pt-2 fs-5 text-end fw-bold">合計 <%= String.format("%,d", allPrice) %>（円）</div>
					<div class="pt-2 fs-5 text-center text-primary for-display">この情報は登録済みです。配達後、配達完了ボタンを押してください。</div>
					<% } else if(msgFlag != null && msgFlag.equals("completed")) { %>
					<div class="pt-1 fs-5 text-center text-primary">配達は完了しています。</div>
					<% } %>
					</div>
				</div>

				<div class="container p-0 mb-5 for-display">
					<div class="row">
						<div class="col">
							<button class="btn btn-dark w-100 btn-lg rounded-pill fs-5" type="button" onClick="window.print()" <%=status%>>領収書 印刷</button>
						</div>
						<div class="col">
							<form onSubmit="return checkDeliSubmit();">
								<button class="btn btn-primary w-100 btn-lg rounded-pill fs-5" type="submit" <%=status%>>配達完了</button>
							</form>
						</div>
						<div class="col">
							<button class="btn btn-secondary w-100 btn-lg rounded-pill fs-5" type="button" onClick="location.href='CustomerSearch.jsp'">検索に戻る</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		</main>

		<footer class="mt-auto" id="footer">
			<p class="for-display">&copy;Infotech Serve Inc.</p>
			<p class="for-print mt-5 fs-1">KIDDA-LA株式会社</p>
		</footer>
	</div>

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
								<button type="button" class="btn btn-secondary text-white fs-5 rounded-pill w-100" data-bs-dismiss="modal">戻る</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="modalDeliConfirm" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header bg-primary text-white">
					<div class="d-inline-flex">
		                <img src="css/Info.png" width="46px" height="46px" alt="">
						<p class="modal-title fs-2">【配達完了確認】</p>
					</div>
				</div>
				<div class="modal-body fs-5 m-0 p-0">
					<table class="table table-bordered fs-5 mb-0">
						<thead class="table-primary">
							<tr>
								<th>NO</th>
								<th>ID</th>
								<th>商品名</th>
								<th>サイズ</th>
								<th>数量</th>
								<th>単価（円）</th>
								<th>小計（円）</th>
							</tr>
						</thead>
						<tbody>
							<%
							int allPrice = 0;
							for(OrderDetail orderDetail : orderDetailList) {
					           	Item item = orderDetail.getItem();
					           	Tax tax = orderDetail.getTax();
					           	int inTax = (int)Math.floor(item.getPrice() * (tax.getRate() + 1));
								int sumPrice = inTax * orderDetail.getQuantity();
							%>
							<tr>
								<td class="text-end"><%= orderDetail.getNo() %></td>
								<td class="text-center"><%= item.getItemId() %></td>
								<td class="text-start"><%= item.getItemName() %></td>
								<td class="text-center"><%= item.getSize() != null ? item.getSize() : "" %></td>
								<td class="text-end"><%= orderDetail.getQuantity() %></td>
								<td class="text-end"><%= String.format("%,d", inTax) %></td>
								<td class="text-end"><%= String.format("%,d", sumPrice) %></td>
							</tr>
							<%
								allPrice = allPrice + sumPrice;
							}
							%>
						</tbody>
					</table>
					<div class="py-2 fs-5 text-end fw-bold bg-primary-subtle">合計 <%= String.format("%,d", allPrice) %>（円）</div>
				</div>
				<form action="KiddaLaController" method="post">
					<input type="hidden" name="command" value="DeliveryComplete">
					<div class="modal-footer justify-content-center">
						<div class="d-flex flex-column w-100">
							<div class="mb-3 fs-5 text-primary">配達を完了します。よろしいですか？</div>
							<div class="row justify-content-center">
								<div class="col-4">
									<button type="submit" class="btn btn-primary fs-5 rounded-pill w-100">確定</button>
								</div>
								<div class="col-4">
									<button type="button" class="btn btn-secondary fs-5 rounded-pill w-100" data-bs-dismiss="modal">取消</button>
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>

</body>
</html>
