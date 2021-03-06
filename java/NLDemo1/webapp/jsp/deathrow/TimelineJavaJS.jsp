<%@ page import = "users.nluthra.MyServerSideClass" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>UI Examples -- Splunk JavaScript SDK</title>
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le styles -->
    <link href="../resources/bootstrap.css" rel="stylesheet">
    <link href="../resources/prettify.css" type="text/css" rel="stylesheet" />
    <link href="../resources/timeline.css" type="text/css" rel="stylesheet" />
    <style type="text/css">
      body {
      }
      
      section {
        padding-top: 60px;
      }
      
      .code {
        font-family: Monaco, 'Andale Mono', 'Courier New', monospace;
      }
      
      button.run {
        float: right;
      }
      
      pre {
        overflow-x: auto;
      }
      
      code {
        font-size: 12px!important;
        background-color: ghostWhite!important;
        color: #444!important;
        padding: 0 .2em!important;
        border: 1px solid #DEDEDE!important;
      }
      
      #timeline-container.active {
        height: 250px;
      }
      
      .secondary-nav ul.dropdown-menu  {
        padding: 10px;
      }
      
      .secondary-nav .dropdown-menu li {
        width: 100%;
      }
      
      .secondary-nav .dropdown-menu li input {
        width: 200px;
        margin: 1px auto;
        margin-bottom: 8px;
      }
    </style>

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="images/favicon.ico">
    <link rel="apple-touch-icon" href="images/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.png">
    
    <script type="text/javascript" src="../resources/json2.js"></script>
    <script type="text/javascript" src="../resources/jquery.min.js"></script>
    <script type="text/javascript" src="../resources/prettify.js"></script>
    <script type="text/javascript" src="../resources/bootstrap.tabs.js"></script>
    <script type="text/javascript" src="../resources/bootstrap.dropdown.js"></script>
    <script type="text/javascript" src="../resources/jquery.placeholder.min.js"></script>
    <script type="text/javascript" src="../resources/client/splunk.js"></script>
    <script >      
      $.fn.pVal = function() {
        return this.hasClass('placeholder') ? '' : this.val();
      };
      
      Async = splunkjs.Async;
      utils = splunkjs.Utils;
      
      $(function() {
        prettyPrint();
        
        var head = $("head");
        
        var injectCode = function(code) {
          var sTag = document.createElement("script");
          sTag.type = "text/javascript";
          sTag.text = code;
          $(head).append(sTag);
          
          return sTag;
        }
        
        var getCode = function(id) {
          var code = "";
          $(id + " pre li").each(function(index, line) {
            var lineCode = "";
            $("span" ,line).each(function(index, span) {
              if ($(span).hasClass("com")) {
                lineCode += " ";
              }
              else {
                lineCode += $(span).text();
              }
            });
            
            lineCode += "\n";
            code += lineCode;
          });
          
          return code;
        }
        
        $("#timeline-run").click(function() {
          // Get the code except comments
          var code = getCode("#timeline");
          
          var tag = null;
          
          // setup the global variables we need
          done = callback = function() {
            $(tag).remove();
          };
          
          $("#timeline-container").html("");
          $("#timeline-container").addClass("active");
          tag = injectCode(code);
        });
        
        $("#chart-run").click(function() {
          // Get the code except comments
          var code = getCode("#chart");
          
          var tag = null;
          
          // setup the global variables we need
          done = callback = function() {
            $(tag).remove();
          };
          
          $("#chart-container").html("");
          $("#chart-container").addClass("active");
          tag = injectCode(code);
        });
      });
    </script>
  </head>

  <body>
    <div class="topbar">
      <div class="fill">
        <div class="container-fluid">
          <a class="brand" href="#">SDK UI Examples</a>
          <ul class="nav">
            <li class="active"><a href="#">Home</a></li>
            <li><a href="#timeline">Timeline</a></li>
            <li><a href="#chart">Charting</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="container">
      
      <section id="timeline">
       <div class="page-header">
          <h1>
            Timeline <small>Loading, creating and updating a timeline</small>
          </h1>
       </div>
       <div class="row">
          <div class="span4">
            <h2>Description</h2>
              <p>
                <p>This samples shows how to asynchronously load the Splunk Timeline control, and perform operations on it. It will create a simple search, and as timeline data is available, will keep updating the timeline. Once the search is done, the job will be cancelled.</p>
                <p><strong>Note</strong>: Due to requiring <code>&lt;canvas&gt;</code>, it only works in IE9+, Firefox 2+, Chrome 4+ and Safari 3.1+.</p>
              </p>
          </div>
         <div class="span12">
            <h3>Code <button class="btn primary run" id="timeline-run">Run</button></h3>
            <div id="timeline-container">
                
            </div>
            <pre class='prettyprint lang-js linenums'>
var timeline = null;
var timelineToken = splunkjs.UI.loadTimeline("../resources/client/splunk.ui.timeline.js", function() {
  // Once we have the charting code, create a chart.
  timeline = new splunkjs.UI.Timeline.Timeline($("#timeline-container"));
});

var searchTerm = 'search index=_internal | head 10000 | stats count(host), count(source) by sourcetype';
var timelineData = <%= MyServerSideClass.getSearchResults("search index=_internal | head 10000 | stats count(host), count(source) by sourcetype", "json_rows") %>;
console.log(timelineData);

// A small utility function to queue up operations on the chart
// until it is ready.
var updateTimeline = function(data) {
  var setData = function() {
    timeline.updateWithJSON(data);
  }
  
  if (timeline === null) {
    splunkjs.UI.ready(timelineToken, function() { setData(); });
  }
  else {
    setData();
  }
};

Async.chain([
  // Update the timeline control
  function(timelineData) {
    updateTimeline(timelineData);
  }
]);
            </pre>
          </div>
        </div>
      </section>
      
      <section id="chart">
       <div class="page-header">
          <h1>
            Charting <small>Loading, creating and updating a chart</small>
          </h1>
       </div>
       <div class="row">
          <div class="span4">
            <h2>Description</h2>
              <p>
                <p>This sample shows how to asynchronously load the Splunk Charting control, and perform operations on it. It will create a simple search, and when the search is done, will fetch results and display them in the chart.</p>
              </p>
          </div>
         <div class="span12">
            <h3>Code <button class="btn primary run" id="chart-run">Run</button></h3>
            <div id="chart-container">
                
            </div>
            <pre class='prettyprint lang-js linenums'>
var http = new splunkjs.ProxyHttp("/proxy");
svc = new splunkjs.Service(http, { 
  scheme: scheme,
  host: host,
  port: port,
  username: username,
  password: password,
  version: version
});

var chart = null; 
var chartToken = splunkjs.UI.loadCharting("../../../client/splunk.ui.charting.js", function() {
  // Once we have the charting code, create a chart and update it.
  chart = new splunkjs.UI.Charting.Chart($("#chart-container"), splunkjs.UI.Charting.ChartType.COLUMN, false);
});

var searchTerm = 'search index=_internal | head 1000 | stats count(host), count(source) by sourcetype';
Async.chain([
  // Login
  function(callback) { svc.login(callback); },
  // Create the job
  function(success, callback) {
    svc.jobs().create(searchTerm, {status_buckets: 300}, callback);
  },
  // Loop until the job is "done"
  function(job, callback) {
    var searcher = new splunkjs.JobManager(job.service, job);
    
    // Move forward once the search is done
    searcher.on("done", callback);
  },
  // Get the final results data
  function(searcher, callback) {
    searcher.job.results({output_mode: "json_cols"}, callback);
  },
  // Update the chart
  function(results, job, callback) { 
    splunkjs.UI.ready(chartToken, function() {
      chart.setData(results, {
        "chart.stackMode": "stacked"
      });
      chart.draw();
      callback(null, job);
    });
  }
],
// And we're done, so make sure we had no error, and
// cancel the job
function(err, job) {
  if (err) {
    console.log(err);
    alert("An error occurred");
  }
  
  if (job) {
    job.cancel();
  }
});
            </pre>
          </div>
        </div>
      </section>
      
      <footer>
        <p>&copy; Splunk 2011-2012</p>
      </footer>

    </div> <!-- /container -->

  </body>
</html>
