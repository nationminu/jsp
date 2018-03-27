package com.rock.sample.v2.listeners;

import java.util.Date;
import java.util.Enumeration;
import java.util.logging.Logger;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

//import org.apache.log4j.Logger;

@WebListener
public class CustomHttpSessionListener implements HttpSessionListener {

//	private Logger log = Logger.getLogger(this.getClass());
	
	/**
	 * Default constructor.
	 */
	public CustomHttpSessionListener() {
		// TODO Auto-generated constructor stub
		System.out.println(">>> CustomHttpSessionListener Loading <<<");
	}

	public void sessionCreated(HttpSessionEvent sessionEvent) {
		// print timestamp & session & getMaxInactiveInterval
		// use date.toString() for the time
		HttpSession session = sessionEvent.getSession();
		Date date = new Date();
		System.out.println(">>> Created Session : [" + session.getId() + "] at [" + date.toString() + "] <<<"); 
		System.out.println(">>> getMaxInactiveInterval : [" + session.getMaxInactiveInterval() + " ] <<<"); 
	}

	public void sessionDestroyed(HttpSessionEvent sessionEvent) {
		// print timestamp & sessionId at the point it is destroyed
		// use date.toString() for the time
		HttpSession session = sessionEvent.getSession();
		Date date = new Date();
		System.out.println(">>> Destroyed Session   : [" + session.getId() + "] at [" + date.toString() + "] <<<");
		System.out.println(">>> getCreationTime     : [" + session.getCreationTime() + " ] <<<");
		System.out.println(">>> getLastAccessedTime : [" + session.getLastAccessedTime() + " ] <<<");
		System.out.println(">>> getMaxInactiveInterval : [" + session.getMaxInactiveInterval() + " ] <<<"); 
	}
	
}
