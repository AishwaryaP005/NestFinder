package com.realestate.servlet;

import java.io.*;
import java.nio.file.Files;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {

    private final String BASE_PATH = "C:/realestate_uploads/";  // keep forward slash

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String path = request.getPathInfo(); // /uploads/file.jpg

        if (path == null || path.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        File file = new File(BASE_PATH + path);

        if (!file.exists() || file.isDirectory()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mime = getServletContext().getMimeType(file.getName());
        if (mime == null) mime = "image/jpeg";

        response.setContentType(mime);

        Files.copy(file.toPath(), response.getOutputStream());
    }
}