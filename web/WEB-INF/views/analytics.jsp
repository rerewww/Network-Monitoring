<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="en"><head><style>
    tr:hover td{
        background: #45E1E8;
    }
</style>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Dashboard Template for Bootstrap</title>

    <!-- Bootstrap core CSS -->
    <link href="/resources/css/bootstrap.min.css" rel="stylesheet">

    <script type="text/javascript" src="/resources/js/packets.js"></script>
    <script type="text/javascript" src="/resources/js/style.js"></script>
    <script type="text/javascript" src="/resources/js/devices.js"></script>
    <script src="/resources/js/lib/jquery.3.3.1.js"></script>

    <!-- Custom styles for this template -->
    <link href="/resources/css/dashboard.css" rel="stylesheet">
</head>

<body>

<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" style="font-weight: bold" href="/network">네트워크 모니터링</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-right">
                <li><a href="/network">Dashboard</a></li>
                <li><a href="/network/viewDevices">Devices</a></li>
                <li class="active"><a href="/network/analytics">Analytics</a></li>
                <li><a href="/network/setting">Setting</a></li>
                <li><a href="/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
            <ul class="nav nav-sidebar">
                <li><a href="/network">Dashboard<span class="sr-only">(current)</span></a></li>
                <li><a href="/network/viewDevices">Devices</a></li>
                <li class="active"><a href="/network/analytics">Analytics</a></li>
                <li><a href="/network/setting">Setting</a></li>
            </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="row placeholders">
            </div>
        </div>
    </div>
</div>

<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200" preserveAspectRatio="none" style="visibility: hidden; position: absolute; top: -100%; left: -100%;"><defs></defs><text x="0" y="10" style="font-weight:bold;font-size:10pt;font-family:Arial, Helvetica, Open Sans, sans-serif;dominant-baseline:middle">200x200</text></svg></body></html>