package com.paperiq.model;

import java.util.Date;
import java.util.List;

public class Paper {
    private int paperId;
    private int userId;
    private String username;
    private String topic;
    private int totalMarks;
    private int rememberMarks;
    private int understandMarks;
    private int applyMarks;
    private int analyzeMarks;
    private int evaluateMarks;
    private int createMarks;
    private Date generatedDate;
    private List<Question> questions;
    
    // Getters and Setters
    public int getPaperId() { return paperId; }
    public void setPaperId(int paperId) { this.paperId = paperId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getTopic() { return topic; }
    public void setTopic(String topic) { this.topic = topic; }
    
    public int getTotalMarks() { return totalMarks; }
    public void setTotalMarks(int totalMarks) { this.totalMarks = totalMarks; }
    
    public int getRememberMarks() { return rememberMarks; }
    public void setRememberMarks(int rememberMarks) { this.rememberMarks = rememberMarks; }
    
    public int getUnderstandMarks() { return understandMarks; }
    public void setUnderstandMarks(int understandMarks) { this.understandMarks = understandMarks; }
    
    public int getApplyMarks() { return applyMarks; }
    public void setApplyMarks(int applyMarks) { this.applyMarks = applyMarks; }
    
    public int getAnalyzeMarks() { return analyzeMarks; }
    public void setAnalyzeMarks(int analyzeMarks) { this.analyzeMarks = analyzeMarks; }
    
    public int getEvaluateMarks() { return evaluateMarks; }
    public void setEvaluateMarks(int evaluateMarks) { this.evaluateMarks = evaluateMarks; }
    
    public int getCreateMarks() { return createMarks; }
    public void setCreateMarks(int createMarks) { this.createMarks = createMarks; }
    
    public Date getGeneratedDate() { return generatedDate; }
    public void setGeneratedDate(Date generatedDate) { this.generatedDate = generatedDate; }
    
    public List<Question> getQuestions() { return questions; }
    public void setQuestions(List<Question> questions) { this.questions = questions; }
}