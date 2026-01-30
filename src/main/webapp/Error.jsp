<%@ page isErrorPage="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ja" class="h-100 overflow-y-scroll">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title> 《エラー》KIDDA-LA 業務システム</title>
<link rel="icon" href="css/favicon.ico">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/KIDDA-LA.css">
<script type="text/javascript" src="js/bootstrap.min.js"></script>
</head>

<body class="d-flex h-100 text-center text-dark">
	<div class="d-flex w-100 h-100 mx-auto flex-column">
		<header class="mb-auto">
			<p class="fs-1 mt-2 mb-1">KIDDA-LA 業務システム</p>
			<p class="fs-3 mt-1 mb-2">《エラー》</p>
		</header>

		<main class="container">
		<div class="d-flex flex-column w-100">
			<div class="row mb-5 justify-content-center">
				<div class="col-8 justify-content-center bg-danger-subtle text-warning-emphasis rounded">
					<p class="fs-4 mt-2 mb-1">${errorMsg}</p>
					<p class="fs-4 mt-1 mb-2">恐れ入りますが，以下のボタンからやり直してください。</p>
				</div>
			</div>
			<div class="row mb-5 justify-content-center">
				<div class="col-4 justify-content-center">
					<button class="btn btn-secondary w-100 btn-lg rounded-pill fs-5" type="button" onClick="location.href='MainMenu.jsp'">メインメニューへ戻る</button>
				</div>
			</div>
		</div>
		</main>

		<footer class="mt-auto">
			<p>&copy;Infotech Serve Inc.</p>
		</footer>
	</div>
</body>
</html>