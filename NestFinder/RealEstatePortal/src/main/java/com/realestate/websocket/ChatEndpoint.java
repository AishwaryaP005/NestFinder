package com.realestate.websocket;

import java.io.IOException;
import java.util.*;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import javax.websocket.server.ServerEndpointConfig;

@ServerEndpoint("/chat")
public class ChatEndpoint {

    // Map userId → session
    private static Map<String, Session> userSessions = new HashMap<>();

    @OnOpen
    public void onOpen(Session session) {

        String userId = session.getQueryString().split("=")[1]; // userId from URL

        userSessions.put(userId, session);

        System.out.println("User connected: " + userId);
    }

    @OnMessage
    public void onMessage(String message, Session session) throws IOException {

        // format: sender|receiver|msg
    	String[] parts = message.split("\\|");

    	String senderId = parts[0];
    	String receiverId = parts[1];
    	String senderName = parts[2];
    	String msg = parts[3];

        System.out.println("From: " + senderName + " To: " + receiverId + " Msg: " + msg);

        Session receiverSession = userSessions.get(receiverId);

        if (receiverSession != null && receiverSession.isOpen()) {
        	receiverSession.getBasicRemote().sendText(senderName + ": " + msg);
        }
    }

    @OnClose
    public void onClose(Session session) {

        userSessions.values().remove(session);
        System.out.println("User disconnected");
    }
}