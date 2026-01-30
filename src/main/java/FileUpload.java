/**
 * ファイルアップロードのサンプル
 * fileUpload.html -> FileUpload.java -> preview.jsp 
 */
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/FileUpload")
// ファイルサイズ制限などを設定
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class FileUpload extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	
        String UPLOAD_DIR = "resources";
        
		//文字コード設定
    	request.setCharacterEncoding("UTF-8");
    	response.setContentType("text/html; charset=UTF-8");

        // 保存先のパスを取得
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + UPLOAD_DIR + "\\"; 
        System.out.println(">>" + uploadFilePath);
        //U:\objworkspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\Kidda-La\resources\
        
        // 保存先のフォルダが無い場合は作成する
        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir(); // フォルダを作成
        }
    	
        // "uploadFile" は HTML の input name="uploadFile" と一致させる
        Part filePart = request.getPart("uploadFile");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        
        // アップロードしたファイルをサーバーに保存
        filePart.write(uploadFilePath + fileName);
        
        try {
            Thread.sleep(5000); // 5秒間停止
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        // プレビュー表示用JSPにファイル名を渡す
        request.setAttribute("uploadedFileName", "/FileUpload/" + UPLOAD_DIR + "/" + fileName);
        request.getRequestDispatcher("/preview.jsp").forward(request, response);
    }
}

