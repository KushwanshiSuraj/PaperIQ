package com.paperiq.dao;

import com.paperiq.model.Question;
import com.paperiq.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {
    
    public List<Question> getAllQuestions() {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT q.*, b.level_name FROM questions q " +
                     "JOIN bloom_level b ON q.level_id = b.level_id ORDER BY q.question_id";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setLevelId(rs.getInt("level_id"));
                q.setLevelName(rs.getString("level_name"));
                q.setTopic(rs.getString("topic"));
                q.setMarks(rs.getInt("marks"));
                q.setDifficulty(rs.getString("difficulty"));
                questions.add(q);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return questions;
    }
    
    public List<Question> getQuestionsByTopicAndLevel(String topic, int levelId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE topic LIKE ? AND level_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + topic + "%");
            pstmt.setInt(2, levelId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setLevelId(rs.getInt("level_id"));
                q.setTopic(rs.getString("topic"));
                q.setMarks(rs.getInt("marks"));
                q.setDifficulty(rs.getString("difficulty"));
                questions.add(q);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return questions;
    }
    
    public boolean addQuestion(Question q) {
        String sql = "INSERT INTO questions (question_text, level_id, topic, marks, difficulty) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, q.getQuestionText());
            pstmt.setInt(2, q.getLevelId());
            pstmt.setString(3, q.getTopic());
            pstmt.setInt(4, q.getMarks());
            pstmt.setString(5, q.getDifficulty());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, pstmt, null);
        }
    }
    
    public Question getQuestionById(int questionId) {
        String sql = "SELECT q.*, b.level_name FROM questions q " +
                     "JOIN bloom_level b ON q.level_id = b.level_id WHERE q.question_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, questionId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setLevelId(rs.getInt("level_id"));
                q.setLevelName(rs.getString("level_name"));
                q.setTopic(rs.getString("topic"));
                q.setMarks(rs.getInt("marks"));
                q.setDifficulty(rs.getString("difficulty"));
                return q;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return null;
    }
    
    public boolean updateQuestion(Question q) {
        String sql = "UPDATE questions SET question_text=?, level_id=?, topic=?, marks=?, difficulty=? WHERE question_id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, q.getQuestionText());
            pstmt.setInt(2, q.getLevelId());
            pstmt.setString(3, q.getTopic());
            pstmt.setInt(4, q.getMarks());
            pstmt.setString(5, q.getDifficulty());
            pstmt.setInt(6, q.getQuestionId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, pstmt, null);
        }
    }
    
    public boolean deleteQuestion(int questionId) {
        String sql = "DELETE FROM questions WHERE question_id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, questionId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, pstmt, null);
        }
    }
    
    public List<BloomLevel> getBloomLevels() {
        List<BloomLevel> levels = new ArrayList<>();
        String sql = "SELECT * FROM bloom_level ORDER BY level_id";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                levels.add(new BloomLevel(rs.getInt("level_id"), rs.getString("level_name")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return levels;
    }
}