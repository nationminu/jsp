<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="javax.management.remote.JMXServiceURL" %>
<%@ page import="javax.management.remote.JMXConnector" %>
<%@ page import="javax.management.remote.JMXConnectorFactory" %>
<%@ page import="javax.management.MBeanServerConnection" %>
<%@ page import="javax.management.ObjectName" %>
<%  
  String sessionId = request.getParameter("sessionid")==null?"":request.getParameter("sessionid").trim(); 
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<link rel="icon" href="../assets/rockplace/images/favicon.ico">
<title>Sample Web Application for Midware [rockPLACE]</title>
<style>
.flex-container {
	display: -webkit-flex;
	display: flex;
	-webkit-flex-flow: row wrap;
	flex-flow: row wrap;
	text-align: center;
}

.flex-container>* {
	padding: 15px;
	-webkit-flex: 1 100%;
	flex: 1 100%;
}

.article {
	text-align: left;
}

header {
	background: black;
	color: white;
}

footer {
	background: #aaa;
	color: white;
}

.nav {
	background: #eee;
}

.nav ul {
	list-style-type: none;
	padding: 0;
}

.nav ul a {
	text-decoration: none;
}

@media all and (min-width: 768px) {
	.nav {
		text-align: left;
		-webkit-flex: 1 auto;
		flex: 1 auto;
		-webkit-order: 1;
		order: 1;
	}
	.article {
		-webkit-flex: 5 0px;
		flex: 5 0px;
		-webkit-order: 2;
		order: 2;
	}
	footer {
		-webkit-order: 3;
		order: 3;
	}
}
</style>
</head> 
<body topmargin=0 leftmargin=0>

<div class="flex-container">
<header>
  <h1> Sample Web Application </h1>
</header>
  
<nav class="nav">
	<ul>
	  <li><a href="html/session.jsp">Session</a></li>  
</ul>
</nav>

<article class="article">
<h1><a href="../">Session Application</a></h1>

<strong> Prerequisite </strong>

<pre>  
** html/session.jsp
// jboss cli user
String[] data=new String[]{"id","password"}

// jboss cli ip/port
String address = "127.0.0.1";
int port = 9999;

** WEB-INF/lib/jboss-client.jar 

** jboss JAVA_OPTS
-Dorg.apache.tomcat.util.ENABLE_MODELER=true 
</pre>  
</p>

 <hr> 
 
 <div> 
 
 <form class="form" method="post">		
	sessionid : <input type="text" class="form-control" id="sessionid" name="sessionid" placeholder="" value="<%=sessionId%>" required/>
 		<input type="submit" value="Continue to Valid"/>
 	</form>
 </div>
 
 <div> 
<%
try{ 

		String address = "127.0.0.1";
		String port = "9999";
		String username="jboss";
		String password="jboss!234";
		
		Map feature=new HashMap();
		String[] data=new String[]{username,password};   
		feature.put(JMXConnector.CREDENTIALS, data);
        

        // Create an RMI connector client and
        // connect it to the RMI connector server 
        System.out.println("\nCreate an RMI connector client and connect it to the RMI connector server");
        //JMXServiceURL url = new JMXServiceURL("service:jmx:rmi:///jndi/rmi://" + address + ":" + port + "/jmxrmi");
        JMXServiceURL url = new JMXServiceURL("service:jmx:remoting-jmx://" + address + ":" + port);
        JMXConnector jmxc = JMXConnectorFactory.connect(url, feature);
        MBeanServerConnection connection = jmxc.getMBeanServerConnection();
        
        ObjectName objectName = new ObjectName("jboss.web:type=Manager,path=/sample,host=default-host");
        
        // invoke jmx operations
        String getLastAccessedTime = connection.invoke(objectName, "getLastAccessedTime", new Object[] { sessionId },new String[] { "java.lang.String" }).toString();
        String getCreationTime = connection.invoke(objectName, "getCreationTime", new Object[] { sessionId },new String[] { "java.lang.String" }).toString();
     	String valueSessionIds = (String)connection.invoke(objectName, "listSessionIds",null,null);
    
        System.out.println("Session with ID="+sessionId+" accessed last time at " + getLastAccessedTime + "("+getCreationTime+")");
		 
        // Jmx sessionId invoke
        if(sessionId != "" && getCreationTime != ""){
       	%>
       	<h3 style="color:blue">Found Session</h3>
           <p>
           	<strong>@<%=sessionId%></strong>
        	getLastAccessedTime=<%=getLastAccessedTime%> ; 
            getCreationTime=<%=getCreationTime%>
            <form action="../SessionController" method="post">
            	<input type="hidden" name="sessionid" value="<%=sessionId%>">
            	<input type="hidden" name="address" value="<%=address%>">
            	<input type="hidden" name="port" value="<%=port%>">
            	<input type="hidden" name="username" value="<%=username%>">
            	<input type="hidden" name="password" value="<%=password%>">
            	
            	<input type="submit" value="expireSession"/>
            </form>
        </p>
	    <%}else{%>
	    	 <h3 style="color:red">Not Found SessionId</h3>
	    <%} 
        
        // Jmx listSessionIds invoke
	    if (valueSessionIds != null) {
		   StringTokenizer tokenizer = new StringTokenizer(valueSessionIds, " ");
	    %>	    
       	<h3>Session List(total <%=tokenizer.countTokens() %>)</h3>
       	<p> 
		<% 
		while (tokenizer.hasMoreTokens())
        { 
           out.println(" " + tokenizer.nextToken() + " <BR>"); 
        }
        %>
		</p> 
		<% 
	    }  
        jmxc.close();   
      	}catch(Exception e){
      		e.printStackTrace();
      	}
  %>
 
 </div> 
</article>

<footer>Copyright &copy; rockplace.co.kr</footer>
</div> 

</body> 
</html>

