<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
  <style>
  tr:hover td{
    background: #45E1E8;
  }
</style>

  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
  <meta name="description" content="">
  <meta name="author" content="">

  <title>Dashboard Template for Bootstrap</title>

  <!-- Bootstrap core CSS -->
  <link href="../../resources/css/bootstrap.min.css" rel="stylesheet">

  <script type="text/javascript" src="/resources/js/packets.js"></script>
  <script type="text/javascript" src="/resources/js/style.js"></script>
  <script type="text/javascript" src="/resources/js/devices.js"></script>
  <script type="text/javascript" src="/resources/js/domControl.js"></script>
  <script type="text/javascript" src="/resources/js/chart.js"></script>
  <script type="text/javascript" src="/resources/js/setting.js"></script>
  <script type="text/javascript" src="/resources/js/renderer.js"></script>
  <script type="text/javascript" src="/resources/js/lib/chart.bundle.min.js"></script>
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
      <a class="navbar-brand" style="font-weight: bold;" href="/network">네트워크 모니터링</a>
    </div>
    <div id="navbar" class="navbar-collapse collapse">
      <ul class="nav navbar-nav navbar-right">
        <li class="active"><a href="/network">Dashboard</a></li>
        <li><a href="/network/viewDevices">Devices</a></li>
        <li><a href="/network/analytics">Analytics</a></li>
        <li><a href="/network/setting">Setting</a></li>
        <li><a href="/logout">Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container-fluid">
  <div class="row">
    <div class="main">
      <div class="row placeholders" style="margin-bottom: 0px">
        <div class="panel panel-default col-xs-6 col-sm-1 placeholder" style="width: 15%; border: 3px solid black;">
          <h4>CPU(%)</h4>
          <span id="cpuAmount" style="font-family: Helvetica; font-size: 70px; font-weight: bold;"></span>
        </div>

        <div class="panel panel-default col-xs-6 col-sm-1 placeholder" style="width: 15%; margin-left: 3%; border: 3px solid black;">
          <h4>Memory(%)</h4>
          <span id="memoryAmount" style="font-family: Helvetica; font-size: 70px; font-weight: bold;"></span>
        </div>

        <div class="col-xs-6 col-sm-2 placeholder">
          <canvas id="mostCalledProgram" height="200px"></canvas>
        </div>

        <div class="col-xs-6 col-sm-3 placeholder" style="display: flex; flex-wrap: wrap; flex-direction: row; width: 20%">
          <div class="switchHeader">Cpu</div>
          <label class="switch">
            <input id="cpuCheck" type="checkbox" onclick="setting.onToggleCpuEvent()">
            <span class="slider"></span>
          </label>

          <div class="switchHeader">Memory</div>
          <label class="switch">
            <input id="memoryCheck" type="checkbox" onclick="setting.onToggleMemoryEvent()">
            <span class="slider"></span>
          </label>

          <div class="switchHeader">Graph</div>
          <label class="switch">
            <input id="graphCheck" type="checkbox" onclick="setting.onTogglePacketEvent()">
            <span class="slider"></span>
          </label>

          <div class="switchHeader">Packets</div>
          <label class="switch">
            <input id="packetsCheck" type="checkbox" onclick="setting.onTogglePacketEvent()">
            <span class="slider"></span>
          </label>

          <div class="switchHeader">ProcName</div>
          <label class="switch">
            <input id="procName" type="checkbox">
            <span class="slider"></span>
          </label>
        </div>
        <div class="col-xs-6 col-sm-3 placeholder" style="width:17%;">
          <form action="/network/download" method="post">
            <button class="action" id="download" name="contents" onclick="packets.download()">Download</button>
          </form>
        </div>
        <div class="col-xs-6 col-sm-3 placeholder" style="width:17%;">
          <form action="/network/commit" method="post">
            <button class="action" id="commit" name="contents" onclick="packets.commit()">Commit</button>
          </form>
        </div>
      </div>
      <div style="border-bottom: 1px solid paleturquoise; margin-bottom: 5px"></div>
      <div class="row placeholders" style="margin-bottom: 0px">
        <div class="col-xs-4 col-sm-3 placeholder" style="width: 50%;">
          <canvas id="packetChart" height="320"></canvas>
        </div>
        <div id='hexDumpInfo' class="col-xs-6 col-sm-3 placeholder" style="
    width: 50%;
">
          <h3 style="padding-bottom: 5px; font-weight: bold;">TCP/IP 4 Layer</h3>
          <h4> Please select packet in table...</h4>
          <details id="ethernetContents" style="display: none"></details>
          <details id="ipContents" style="display: none"></details>
          <details id="tcpContents" style="display: none"></details>
          <details id="dumpContents" style="display: none"></details>
        </div>
      </div>

      <h4 class="sub-header" style="font-weight: bold; margin-top: 0px">
        <c:choose>
          <c:when test="${deviceName ne ''}">
              ${deviceName}
          </c:when>
          <c:otherwise>
              Select network device...
          </c:otherwise>
        </c:choose>
      </h4>
      <table class="table table-striped" style="
    margin-bottom: 0;">
        <thead>
        <tr>
          <th id='headerNum' style="width: 10%">Number</th>
          <th id='headerLa' style="width: 20%">LocalAddress</th>
          <th id='headerRe' style="width: 20%">RemoteAddress</th>
          <th id='headerPr' style="width: 10%">Protocol</th>
          <th id='headerIn'>Info</th>
        </tr>
        </thead>

      </table><div class="table-responsive" style="
    height: 400px;
">
      <table id="packets" class="table table-striped">
        <tbody>
        </tbody>
      </table></div>
    </div>
  </div>
</div>
<script>
    devices.checkDevice();
</script>

<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200" preserveAspectRatio="none" style="visibility: hidden; position: absolute; top: -100%; left: -100%;"><defs></defs><text x="0" y="10" style="font-weight:bold;font-size:10pt;font-family:Arial, Helvetica, Open Sans, sans-serif;dominant-baseline:middle">200x200</text></svg></body></html>