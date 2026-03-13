package com.paperiq.model;

public class BloomLevel {
    private int levelId;
    private String levelName;
    
    public BloomLevel() {}
    
    public BloomLevel(int levelId, String levelName) {
        this.levelId = levelId;
        this.levelName = levelName;
    }
    
    public int getLevelId() {
        return levelId;
    }
    
    public void setLevelId(int levelId) {
        this.levelId = levelId;
    }
    
    public String getLevelName() {
        return levelName;
    }
    
    public void setLevelName(String levelName) {
        this.levelName = levelName;
    }
}