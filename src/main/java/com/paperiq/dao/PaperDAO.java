package com.paperiq.dao;

import com.paperiq.model.Paper;
import com.paperiq.model.Question;
import com.paperiq.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaperDAO {
    
    public int savePaper(Paper paper) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int paperId = 0;
        
        String sql = "INSERT INTO generated_papers (user_id, username, topic, total_marks, " +
                     "remember_marks, understand_marks, apply_marks, analyze_marks, " +
                     "evaluate_marks, create_marks) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, paper.getUserId());
            pstmt.setString(2, paper.getUsername());
            pstmt.setString(3, paper.getTopic());
            pstmt.setInt(4, paper.getTotalMarks());
            pstmt.setInt(5, paper.getRememberMarks());
            pstmt.setInt(6, paper.getUnderstandMarks());
            pstmt.setInt(7, paper.getApplyMarks());
            pstmt.setInt(8, paper.getAnalyzeMarks());
            pstmt.setInt(9, paper.getEvaluateMarks());
            pstmt.setInt(10, paper.getCreateMarks());
            
            pstmt.executeUpdate();
            
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                paperId = rs.getInt(1);
            }
            
            // Save questions if we have paperId and questions
            if (paperId > 0 && paper.getQuestions() != null) {
                savePaperQuestions(paperId, paper.getQuestions());
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        
        return paperId;
    }
    
    private void savePaperQuestions(int paperId, List<Question> questions) {
        String sql = "INSERT INTO paper_questions (paper_id, question_id, question_text, level_name, marks, question_number) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            int qNum = 1;
            for (Question q : questions) {
                pstmt.setInt(1, paperId);
                pstmt.setInt(2, q.getQuestionId());
                pstmt.setString(3, q.getQuestionText());
                pstmt.setString(4, q.getLevelName());
                pstmt.setInt(5, q.getMarks());
                pstmt.setInt(6, qNum++);
                pstmt.addBatch();
            }
            
            pstmt.executeBatch();
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, null);
        }
    }
    
    public List<Paper> getAllPapers() {
        List<Paper> papers = new ArrayList<>();
        String sql = "SELECT * FROM generated_papers ORDER BY generated_date DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Paper p = extractPaperFromResultSet(rs);
                papers.add(p);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        
        return papers;
    }
    
    public List<Paper> getPapersByUser(int userId) {
        List<Paper> papers = new ArrayList<>();
        String sql = "SELECT * FROM generated_papers WHERE user_id = ? ORDER BY generated_date DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Paper p = extractPaperFromResultSet(rs);
                papers.add(p);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        
        return papers;
    }
    
    private Paper extractPaperFromResultSet(ResultSet rs) throws SQLException {
        Paper p = new Paper();
        p.setPaperId(rs.getInt("paper_id"));
        p.setUserId(rs.getInt("user_id"));
        p.setUsername(rs.getString("username"));
        p.setTopic(rs.getString("topic"));
        p.setTotalMarks(rs.getInt("total_marks"));
        p.setRememberMarks(rs.getInt("remember_marks"));
        p.setUnderstandMarks(rs.getInt("understand_marks"));
        p.setApplyMarks(rs.getInt("apply_marks"));
        p.setAnalyzeMarks(rs.getInt("analyze_marks"));
        p.setEvaluateMarks(rs.getInt("evaluate_marks"));
        p.setCreateMarks(rs.getInt("create_marks"));
        p.setGeneratedDate(rs.getTimestamp("generated_date"));
        return p;
    }
}