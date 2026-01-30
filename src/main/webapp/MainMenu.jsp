<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ja" class="h-100 overflow-y-scroll">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>《メインメニュー》 KIDDA-LA 業務システム</title>
<link rel="icon" href="css/favicon.ico">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/KIDDA-LA.css">
<script type="text/javascript" src="js/bootstrap.min.js"></script>
</head>

<body class="d-flex h-100 text-center text-dark">
	<div class="d-flex w-100 mx-auto flex-column">
		<header class="mb-auto">
			<p class="fs-1 mt-2 mb-1">KIDDA-LA 業務システム</p>
			<p class="fs-3 mt-1 mb-2">《メインメニュー》</p>
		</header>

		<main class="container">
		<div class="d-flex flex-column w-100">
			<div class="row mb-5 justify-content-center">
				<div class="col-4 justify-content-center">
					<button class="btn btn-success rounded-pill btn-lg fs-3 m-1 text-white w-100" type="submit" form="fm">01　注文管理</button>
				</div>
			</div>
		</div>
		</main>

		<footer class="mt-auto" id="ftr">
			<p>&copy;Infotech Serve Inc.</p>
		</footer>
	</div>
	<form action="KiddaLaController" method="post" id="fm">
		<input type="hidden" name="command" value="CustomerSearchDisplay">
	</form>
</body>
</html>