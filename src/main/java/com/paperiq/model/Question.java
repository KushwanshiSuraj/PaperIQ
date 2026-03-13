package com.paperiq.model;

public class Question {
    private int questionId;
    private String questionText;
    private int levelId;
    private String levelName;
    private String topic;
    private int marks;
    private String difficulty;
    
    public Question() {}
    
    public Question(int questionId, String questionText, int levelId, String levelName, 
                   String topic, int marks, String difficulty) {
        this.questionId = questionId;
        this.questionText = questionText;
        this.levelId = levelId;
        this.levelName = levelName;
        this.topic = topic;
        this.marks = marks;
        this.difficulty = difficulty;
    }
    
    // Getters and Setters
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    
    public int getLevelId() { return levelId; }
    public void setLevelId(int levelId) { this.levelId = levelId; }
    
    public String getLevelName() { return levelName; }
    public void setLevelName(String levelName) { this.levelName = levelName; }
    
    public String getTopic() { return topic; }
    public void setTopic(String topic) { this.topic = topic; }
    
    public int getMarks() { return marks; }
    public void setMarks(int marks) { this.marks = marks; }
    
    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
}