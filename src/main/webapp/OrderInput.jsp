<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" errorPage="Error.jsp" %>
<%@ page import="model.Customer" %>
<%@ page import="model.Item" %>
<%@ page import="model.Tax" %>
<%@ page import="java.util.ArrayList"%>
<%
	Customer customer = (Customer)session.getAttribute("customer");
	@SuppressWarnings("unchecked")
	String[][] itemData = (String[][])session.getAttribute("itemData");
	Tax tax = (Tax)session.getAttribute("tax");
	String msgFlag = (String)request.getAttribute("msgFlag");
	String errorMsg = (String)request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="ja" class="overflow-y-scroll">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>《注文／配達確認／顧客情報変更》 KIDDA-LA 業務システム</title>
	<link rel="icon" href="css/favicon.ico">
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/KIDDA-LA.css">
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<script type="text/javascript">
	function incrementValue(id) {
		quantity = document.getElementById("quantity" + id).value;
		if(Number(quantity) < 20) {
			document.getElementById("quantity" + id).value = Number(quantity) + 1;
			price = document.getElementById("price" + id).innerHTML;
			sumPrice = (Number(quantity) + 1) * Number(price.replace(/,/g, ''));
			document.getElementById("sumPrice" + id).innerHTML = sumPrice.toLocaleString();
		}
		allPrice = 0;
		iMax = document.getElementById("itemList").rows.length - 1;
		for(i = 1; i <= iMax; i++) {
			sumPrice = document.getElementById("sumPrice" + i).innerHTML;
			allPrice += Number(sumPrice.replace(/,/g, ''));
		}
		document.getElementById("allPrice").innerHTML = "合計 " + allPrice.toLocaleString() + "（円）";
	}

	function decrementValue(id) {
		quantity = document.getElementById("quantity" + id).value;
		if(Number(quantity) > 0) {
			document.getElementById("quantity" + id).value = Number(quantity) - 1;
			price = document.getElementById("price" + id).innerHTML;
			sumPrice = (Number(quantity) - 1) * Number(price.replace(/,/g, ''));
			document.getElementById("sumPrice" + id).innerHTML = sumPrice.toLocaleString();
		}
		allPrice = 0;
		iMax = document.getElementById("itemList").rows.length - 1;
		for(i = 1; i <= iMax; i++) {
			sumPrice = document.getElementById("sumPrice" + i).innerHTML;
			allPrice += Number(sumPrice.replace(/,/g, ''));
		}
		document.getElementById("allPrice").innerHTML = "合計 " + allPrice.toLocaleString() + "（円）";
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

	function showModalCustConfirm(custId, custName, kana, tel, address) {
		modal = new bootstrap.Modal(document.getElementById('modalCustConfirm'));
		document.getElementById('modalCustConfirm_custId').value = custId;
		document.getElementById('modalCustConfirm_custName').value = custName;
		document.getElementById('modalCustConfirm_kana').value = kana;
		document.getElementById('modalCustConfirm_tel').value = tel;
		document.getElementById('modalCustConfirm_address').value = address;
		modal.show();
		document.getElementById('body').style.paddingRight = '0px';
		document.getElementById('footer').style.paddingRight = '0px';
        document.getElementById('modalCustConfirm').style.paddingRight = '0px';
	}

	function showModalOrderConfirm(itemIdAry, itemNameAry, sizeAry, quantityAry, priceAry, sumPriceAry, allPrice) {
		modal = new bootstrap.Modal(document.getElementById('modalOrderConfirm'));
		tableBody = '';
        for(i = 0; i < itemIdAry.length; i++) {
        	if(quantityAry[i] > 0) {
				tableBody += '<tr>';
        	} else {
        		tableBody += '<tr class="d-none">';
        	}
			tableBody += '<td class="text-center">' + itemIdAry[i] + '</td>';
			tableBody += '<td class="text-start">' + itemNameAry[i] + '</td>';
			tableBody += '<td class="text-center">' + sizeAry[i] + '</td>';
			tableBody += '<td class="text-end">' + quantityAry[i] + '<input type="hidden" name="quantity" value="' + quantityAry[i] + '" form="fm2"></td>';
			tableBody += '<td class="text-end">' + priceAry[i] + '</td>';
			tableBody += '<td class="text-end">' + sumPriceAry[i] + '</td>';
			tableBody += '</tr>';
 		}
       	document.getElementById('modalOrderConfirm_tbody').innerHTML = tableBody;
       	document.getElementById('modalOrderConfirm_allPrice').innerHTML = allPrice;
		modal.show();
		document.getElementById('body').style.paddingRight = '0px';
		document.getElementById('footer').style.paddingRight = '0px';
        document.getElementById('modalOrderConfirm').style.paddingRight = '0px';
	}

	function checkCustSubmit() {
		if(document.getElementById('tel').value == ""
			|| document.getElementById('custId').value == ""
			|| document.getElementById('custName').value == ""
			|| document.getElementById('kana').value == ""
			|| document.getElementById('tel').value == ""
			|| document.getElementById('address').value == "") {
		} else {
			custId = document.getElementById('custId').value;
			custName = document.getElementById('custName').value;
			kana = document.getElementById('kana').value;
			tel = document.getElementById('tel').value;
			address = document.getElementById('address').value;
			showModalCustConfirm(custId, custName, kana, tel, address);
		}
		return false;
	}

	function checkOrderSubmit(iMax) {
		itemIdAry = [];
		itemNameAry = [];
		sizeAry = [];
		quantityAry = [];
		priceAry = [];
		sumPriceAry = [];
		flag = 0;
		for(i = 1; i <= iMax; i++) {
			itemIdAry.push(document.getElementById("itemId" + i).innerHTML);
			itemNameAry.push(document.getElementById("itemName" + i).innerHTML);
			sizeAry.push(document.getElementById("size" + i).innerHTML);
			quantity = Number(document.getElementById("quantity" + i).value);
			if(quantity > 0) {
				flag = 1;
			}
			quantityAry.push(quantity);
			priceAry.push(document.getElementById("price" + i).innerHTML);
			sumPriceAry.push(document.getElementById("sumPrice" + i).innerHTML);
		}
		allPrice = document.getElementById("allPrice").innerHTML;
		if(flag == 1) {
			showModalOrderConfirm(itemIdAry, itemNameAry, sizeAry, quantityAry, priceAry, sumPriceAry, allPrice);
		} else {
			showModalConfirm("【エラー】", "注文数量を入力してください。", "error");
		}
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
        const forms = document.querySelectorAll('.needs-validation');
        Array.prototype.slice.call(forms).forEach(function(form) {
            form.addEventListener('submit', function(event) {
                if(!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
        adjustFooter();
		<% if(errorMsg != null) { %>
		showModalConfirm("【注文情報登録失敗】", "${errorMsg}", "error");
        <% } else if(msgFlag != null && msgFlag.equals("noList")) { %>
        showModalConfirm("【確認】", "注文情報はありません。", "warning");
		<% } else if(msgFlag != null && msgFlag.equals("modified")) { %>
		showModalConfirm("【顧客情報変更完了】", "顧客情報を更新しました。", "info");
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
			<p class="fs-3 mt-1 mb-2">《注文／配達確認／顧客情報変更》</p>
		</header>

		<main class="container">
		<div class="row">
			<div class="offset-1 col-10 d-flex flex-column">
				<form class="needs-validation" novalidate onSubmit="return checkCustSubmit();">
					<div class="card mb-3">
						<div class="card-header fs-5 bg-warning">顧客情報</div>
						<div class="card-body bg-warning-subtle text-start">
							<div class="row mb-1">
								<label for="custId" class="col-2 col-form-label fs-5">ID</label>
								<div class="col-10">
									<input class="form-control-plaintext fs-5" id="custId" type="text" placeholder="" value="<%=customer.getCustId()%>" required>
								</div>
							</div>
							<div class="row mb-1">
								<label for="custName" class="col-2 col-form-label fs-5">氏名</label>
								<div class="col-10">
									<input class="form-control fs-5" id="custName" type="text" placeholder="例：山田太郎" value="<%=customer.getCustName()%>" required>
									<div class="invalid-feedback">氏名を入力してください</div>
								</div>
							</div>
							<div class="row mb-1">
								<label for="kana" class="col-2 col-form-label fs-5">氏名カナ</label>
								<div class="col-10">
									<input class="form-control fs-5" id="kana" type="text" placeholder="例：ヤマダタロウ" value="<%=customer.getKana()%>" required>
									<div class="invalid-feedback">氏名カナを入力してください</div>
								</div>
							</div>
							<div class="row mb-1">
								<label for="tel" class="col-2 col-form-label fs-5">電話番号</label>
								<div class="col-10">
									<input class="form-control fs-5" id="tel" type="text" placeholder="例：09012345678" value="<%=customer.getTel()%>" required>
									<div class="invalid-feedback">電話番号を入力してください</div>
								</div>
							</div>
							<div class="row mb-1">
								<label for="address" class="col-2 col-form-label fs-5">住所</label>
								<div class="col-10">
									<input class="form-control fs-5" id="address" type="text" placeholder="例：東京都千代田区神田小川町１－８－５" value="<%=customer.getAddress()%>" required>
									<div class="invalid-feedback">住所を入力してください</div>
								</div>
							</div>
						</div>
					</div>

					<div class="container p-0 mb-5">
						<div class="row justify-content-center">
							<div class="col-4">
								<button class="btn btn-primary w-100 btn-lg rounded-pill fs-5" type="submit" form="fm1">配達確認</button>
							</div>
							<div class="col-4">
								<button class="btn btn-warning w-100 btn-lg rounded-pill fs-5" type="submit">顧客情報変更</button>
							</div>
							<div class="col-4">
								<button class="btn btn-secondary w-100 btn-lg rounded-pill fs-5" type="button" onClick="location.href='CustomerSearch.jsp'">戻る</button>
							</div>
						</div>
					</div>
				</form>

				<form onSubmit="return checkOrderSubmit(<%=itemData.length %>);">
				<div class="card mb-3">
					<div class="card-header fs-5 bg-success text-white">注文内容</div>
					<div class="card-body pb-2 bg-success-subtle">
					<table class="table table-bordered fs-5 mb-0" id="itemList">
						<thead class="table-success">
							<tr>
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
							int i = 1;
							for(String[] item : itemData) {
							%>
							<tr>
							    <td class="align-middle text-center" id="<%="itemId" + i%>"><%=item[0] %></td>
								<td class="align-middle text-start" id="<%="itemName" + i%>"><%=item[1] %></td>
								<td class="align-middle text-center" id="<%="size" + i%>"><%=item[2] != null ? item[2] : ""%></td>
								<td>
									<div class="input-group">
										<button type="button" class="btn bg-danger-subtle rounded-start-pill fs-5" onClick="incrementValue('<%=i%>');">＋</button>
										<input type="number" class="form-control text-end fs-5" id="<%="quantity" + i%>" value="0" readonly>
										<button type="button" class="btn bg-info-subtle rounded-end-pill fs-5" onClick="decrementValue('<%=i%>');">－</button>
									</div>
								</td>
								<td class="align-middle text-end" id="<%="price" + i%>"><%= item[4] %></td>
								<td class="align-middle text-end" id="<%="sumPrice" + i++%>">0</td>
							</tr>
							<%
			  				}
							%>
						</tbody>
					</table>
					<div class="pt-2 fs-5 text-end fw-bold" id="allPrice">合計 0（円）</div>
					</div>
				</div>

				<div class="container p-0 mb-5">
					<div class="row justify-content-center">
						<div class="col-4">
							<button class="btn btn-success w-100 btn-lg rounded-pill fs-5" type="submit">注文登録</button>
						</div>
						<div class="col-4">
							<button class="btn btn-secondary w-100 btn-lg rounded-pill fs-5" type="button" onClick="location.href='CustomerSearch.jsp'">戻る</button>
						</div>
					</div>
				</div>
				</form>
			</div>
		</div>
		</main>

		<footer class="mt-auto" id="footer">
			<p>&copy;Infotech Serve Inc.</p>
		</footer>
	</div>
	<form action="KiddaLaController" method="post" id="fm1">
		<input type="hidden" name="command" value="DeliveryConfirm">
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

	<div class="modal fade" id="modalCustConfirm" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-lg modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header bg-warning">
					<div class="d-inline-flex">
		                <img src="css/Info.png" width="46px" height="46px" alt="">
						<p class="modal-title fs-2">【顧客情報変更確認】</p>
					</div>
				</div>
				<form action="KiddaLaController" method="post">
					<input type="hidden" name="command" value="CustomerModify">

					<div class="modal-body text-start fs-5">
						<div class="row mb-1">
							<label for="custId" class="offset-2 col-2 col-form-label fs-5">ID</label>
							<div class="col-6">
								<input class="form-control-plaintext fs-5" name="custId" id="modalCustConfirm_custId" type="text" value="">
							</div>
						</div>
						<div class="row mb-1">
							<label for="custName" class="offset-2 col-2 col-form-label fs-5">氏名</label>
							<div class="col-6">
								<input class="form-control-plaintext fs-5" name="custName" id="modalCustConfirm_custName" type="text" value="">
							</div>
						</div>
						<div class="row mb-1">
							<label for="kana" class="offset-2 col-2 col-form-label fs-5">氏名カナ</label>
							<div class="col-6">
								<input class="form-control-plaintext fs-5" name="kana" id="modalCustConfirm_kana" type="text" value="">
							</div>
						</div>
						<div class="row mb-1">
							<label for="tel" class="offset-2 col-2 col-form-label fs-5">電話番号</label>
							<div class="col-6">
								<input class="form-control-plaintext fs-5" name="tel" id="modalCustConfirm_tel" type="text" value="">
							</div>
						</div>
						<div class="row mb-1">
							<label for="address" class="offset-2 col-2 col-form-label fs-5">住所</label>
							<div class="col-6">
								<input class="form-control-plaintext fs-5" name="address" id="modalCustConfirm_address" type="text" value="">
							</div>
						</div>
					</div>
					<div class="modal-footer justify-content-center">
						<div class="d-flex flex-column w-100">
							<div class="mb-3 fs-5 text-warning-emphasis">この内容でよろしければ、〔確定〕ボタンを押してください。</div>
							<div class="row justify-content-center">
								<div class="col-4">
									<button type="submit" class="btn btn-warning fs-5 rounded-pill w-100">確定</button>
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

	<div class="modal fade" id="modalOrderConfirm" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header bg-success text-white">
					<div class="d-inline-flex">
		                <img src="css/Info.png" width="46px" height="46px" alt="">
						<p class="modal-title fs-2">【注文情報登録確認】</p>
					</div>
				</div>
				<div class="modal-body fs-5 m-0 p-0">
					<table class="table table-bordered fs-5 mb-0">
						<thead class="table-success">
							<tr>
								<th>ID</th>
								<th>商品名</th>
								<th>サイズ</th>
								<th>数量</th>
								<th>単価（円）</th>
								<th>小計（円）</th>
							</tr>
						</thead>
						<tbody id="modalOrderConfirm_tbody"></tbody>
					</table>
					<div class="py-2 fs-5 text-end fw-bold bg-success-subtle" 
						id="modalOrderConfirm_allPrice"></div>
				</div>
				<div class="modal-footer justify-content-center">
					<div class="d-flex flex-column w-100">
						<div class="mb-3 fs-5 text-success">
							この内容でよろしければ、〔確定〕ボタンを押してください。</div>
						<div class="row justify-content-center">
							<div class="col-4">
								<button type="submit" 
									class="btn btn-success fs-5 rounded-pill w-100" 
									form="fm2">確定</button>
							</div>
							<div class="col-4">
								<button type="button" 
									class="btn btn-secondary fs-5 rounded-pill w-100" 
									data-bs-dismiss="modal">取消</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<form action="KiddaLaController" method="post" id="fm2">
		<input type="hidden" name="command" value="OrderRegister">
	</form>

</body>
</html>