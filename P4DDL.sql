-- Create a new Database  
CREATE DATABASE CrimeTracker -- Start using the new DB 
USE CrimeTracker -- Create Person table 

--FIRST RUN CREATE DATABASE QUERY "CREATE DATABASE CrimeTracker" SEPARATELY ,SECONDLY RUN "USE DATABASE CRIMETRACKER" ALONG WITH CODE TO CREATE TABLES BELOW

DROP TABLE IF EXISTS Person

CREATE TABLE Person ( 
     PersonID int NOT NULL IDENTITY(1,1) 
    ,[Name] varchar(200) 
    ,Gender varchar(2) CONSTRAINT Gender_Chk CHECK (Gender in ('M','F','O')) 
    ,DateOfBirth date    
    ,Contact varchar(20)
    ,StreetAddress varchar(200) 
    ,City varchar(400) 
    ,State varchar(200) 
    ,ZIP varchar(20) 
    CONSTRAINT Person_PK PRIMARY KEY (PersonID) 
) 
DROP TABLE IF EXISTS Police 
CREATE TABLE Police ( 
    PoliceID int NOT NULL 
    ,BadgeNumber varchar(100) 
    ,YearsOfService int 
    ,Department varchar(200) 
    CONSTRAINT Police_PK PRIMARY KEY (PoliceID) 
    CONSTRAINT Police_FK FOREIGN KEY (PoliceID) REFERENCES Person(PersonID) 
) -- Create Location table 
DROP TABLE IF EXISTS Location 
CREATE TABLE Location ( 
    LocationID int NOT NULL IDENTITY(1,1) 
    ,Street varchar(200) 
    ,City varchar(200) 
    ,[State] varchar(200) 
    ,[ZIP] varchar(100) 
    ,[Surveillance?] bit -- stores 0 for FALSE, 1 for TRUE 
    CONSTRAINT Location_PK PRIMARY KEY (LocationID) 
) -- Create Property Table 
DROP TABLE IF EXISTS Property 
CREATE TABLE Property ( 
    PropertyID int NOT NULL IDENTITY(1,1) 
    ,PropertyType varchar(100) 
    ,[Description] varchar(500) 
    ,EstimatedValue float 
    CONSTRAINT Property_PK PRIMARY KEY (PropertyID) 
) 
-- Create Event table 
DROP TABLE IF EXISTS Event 
CREATE TABLE Event ( 
    EventID Int NOT NULL IDENTITY(1,1) 
    ,EventType varchar(50) CONSTRAINT EventType_CHK CHECK (EventType in ('Burglary', 'Theft'))   
    ,[DateTime] datetime 
    ,[Description] varchar(500)  
    ,[Severity] varchar(20) CONSTRAINT Severity_CHK CHECK (Severity in ('High', 'Medium','Low')) 
    ,[LocationID] int NOT NULL 
    ,PoliceID int NOT NULL 
     
    CONSTRAINT Event_PK PRIMARY KEY (EventID) 
    ,CONSTRAINT Event_FK1 FOREIGN KEY (LocationID) REFERENCES [Location](LocationID) 
    ,CONSTRAINT Event_FK2 FOREIGN KEY (PoliceID) REFERENCES [Person](PersonID) 
) -- Create Burglary table 
DROP TABLE IF EXISTS Burglary 
CREATE TABLE Burglary ( 
     BurglaryEventID int NOT NULL 
    ,BurglaryType varchar(100)  
    ,EstimatedLoss int  
    ,IsSecurityCompromised varchar(1) -- Y means Yes, N means No 
    
     
     CONSTRAINT Burglary_PK PRIMARY KEY (BurglaryEventID) 
    ,CONSTRAINT Burglary_FK FOREIGN KEY (BurglaryEventID) REFERENCES [Event](EventID) 
) -- Create Theft Table 
DROP TABLE IF EXISTS Theft 
CREATE TABLE Theft ( 
    TheftEventID int NOT NULL  
    ,TheftType varchar(100) 
    ,EstimatedLoss int 
    ,MethodOfTheft varchar(200) 
    ,ItemStolen varchar(100) 
    ,IsReported varchar(1)  -- Y means Yes and N means No 
    CONSTRAINT Theft_PK PRIMARY KEY (TheftEventID) 
    CONSTRAINT Theft_FK FOREIGN KEY (TheftEventID) REFERENCES Event(EventID) 
) -- Create Investigation Table 
DROP TABLE IF EXISTS Investigation 
CREATE TABLE Investigation ( 
    InvestigationID int NOT NULL IDENTITY(1,1)   
    ,RelatedEventID int NOT NULL 
    ,StartDate date 
    ,EndDate date    
    ,InvestigationStatus varchar(200)    
    ,IsEvidenceCollected varchar(1) -- Y means Yes and N means No    
    ,#SuspectsIdentified int 
    ,Findings varchar(200) 
    ,ResolutionStatus varchar(100) 
    CONSTRAINT Investigation_PK PRIMARY KEY (InvestigationID) 
    CONSTRAINT Investigation_FK FOREIGN KEY (RelatedEventID) REFERENCES Event(EventID) 
) -- Create Victim Table 
DROP TABLE IF EXISTS Victim 
CREATE TABLE Victim ( 
     VictimID int NOT NULL   
    ,VictimType varchar(100) 
    ,EmergencyContact varchar(50)    
    ,VulnerabilityStatus varchar(50) 
    CONSTRAINT Victim_PK PRIMARY KEY (VictimID) 
    CONSTRAINT Victim_FK FOREIGN KEY (VictimID) REFERENCES Person(PersonID) 
) -- Create Witness Table 
DROP TABLE IF EXISTS Witness 
CREATE TABLE Witness ( 
     WitnessID int NOT NULL 
    ,Testimony varchar(500) 
    ,DateOfTestimony date 
    ,StatementType varchar(100) 
    CONSTRAINT Witness_PK PRIMARY KEY (WitnessID) 
    CONSTRAINT Witness_FK FOREIGN KEY (WitnessID) REFERENCES Person(PersonID) 
) -- Create Suspect Table 
DROP TABLE IF EXISTS Suspect 
CREATE TABLE Suspect ( 
    SuspectID int NOT NULL 
    ,SuspectStatus varchar(500)  
    ,ArrestDate date 
    ,LastKnownLocation  varchar(200) 
    ,PriorConvictions bit -- 0 means No and 1 means Yes 
    ,Height float 
    ,[Weight] float  
    ,EyeColor varchar(20) 
    CONSTRAINT Suspect_PK PRIMARY KEY (SuspectID) 
    CONSTRAINT Suspect_FK FOREIGN KEY (SuspectID) REFERENCES Person(PersonID) 
) -- Create Evidence Table 
DROP TABLE IF EXISTS Evidence 
CREATE TABLE Evidence ( 
    EvidenceID int NOT NULL IDENTITY(1,1) 
    ,InvestigationID int NOT NULL 
    ,EvidenceType varchar(200)   
    ,CollectionDate date 
    ,[Description] varchar(500) 
    CONSTRAINT Evidence_PK PRIMARY KEY (EvidenceID) 
    CONSTRAINT Evidence_FK FOREIGN KEY (InvestigationID) REFERENCES 
Investigation(InvestigationID) 
) -- Create Response Table 
DROP TABLE IF EXISTS Response 
CREATE TABLE Response ( 
     ResponseTimeID int NOT NULL IDENTITY(1,1) 
    ,EventID int NOT NULL 
    ,PoliceID int NOT NULL 
    ,TimeReported datetime 
    ,TimeArrived datetime 
    CONSTRAINT Response_PK PRIMARY KEY (ResponseTimeID) 
    CONSTRAINT Response_FK1 FOREIGN KEY (EventID) REFERENCES [Event](EventID) 
    ,CONSTRAINT Response_FK2 FOREIGN KEY (PoliceID) REFERENCES Police(PoliceID) 
) -- Create Feedback Table 
DROP TABLE IF EXISTS Feedback 
CREATE TABLE Feedback ( 
    FeedbackID int NOT NULL IDENTITY(1,1) 
    ,EventID int NOT NULL 
    ,VictimID int NOT NULL 
    ,FeedbackDate date   
    ,FeedbackText varchar(500)   
    ,Rating int 
    CONSTRAINT Feedback_PK PRIMARY KEY (FeedbackID) 
    CONSTRAINT Feedback_FK1 FOREIGN KEY (EventID) REFERENCES [Event](EventID) 
    ,CONSTRAINT Feedback_FK2 FOREIGN KEY (VictimID) REFERENCES Victim (VictimID) 
) -- Create Role Table 
DROP TABLE IF EXISTS Role 
CREATE TABLE Role ( 
    EventID int NOT NULL 
    ,PersonID int NOT NULL 
    ,[Role] varchar(200)    CONSTRAINT Role_CHK CHECK ([Role] in 
('Police','Victim','Witness','Suspect')) 
    ,DateOfAssignment date 
    CONSTRAINT Role_PK PRIMARY KEY (EventID,PersonID) 
    CONSTRAINT Role_FK1 FOREIGN KEY (EventID) REFERENCES [Event](EventID) 
    ,CONSTRAINT Role_FK2 FOREIGN KEY (PersonID) REFERENCES Person(PersonID) 
) -- Create VictimInvolvement Table 
DROP TABLE IF EXISTS VictimInvolvement 
CREATE TABLE VictimInvolvement ( 
    EventID int NOT NULL 
    ,VictimID int NOT NULL 
    ,InjuryLevel varchar(200) 
    CONSTRAINT VI_PK PRIMARY KEY (EventID,VictimID) 
    CONSTRAINT VI_FK1 FOREIGN KEY (EventID) REFERENCES [Event](EventID) 
    ,CONSTRAINT VI_FK2 FOREIGN KEY (VictimID) REFERENCES Victim(VictimID) 
) -- Create SuspectInvolvement Table 
DROP TABLE IF EXISTS SuspectInvolvement 
CREATE TABLE SuspectInvolvement ( 
    EventID int NOT NULL 
    ,SuspectID int NOT NULL 
    ,InvolvementLevel varchar(200) 
    CONSTRAINT SI_PK PRIMARY KEY (EventID,SuspectID) 
    CONSTRAINT SI_FK1 FOREIGN KEY (EventID) REFERENCES [Event](EventID) 
    ,CONSTRAINT SI_FK2 FOREIGN KEY (SuspectID) REFERENCES Suspect(SuspectID) 
) -- Create WitnessInvolvement Table 
DROP TABLE IF EXISTS WitnessInvolvement 
CREATE TABLE WitnessInvolvement ( 
    EventID int NOT NULL 
    ,WitnessID int NOT NULL 
    ,InvolvementLevel varchar(100) 
    CONSTRAINT WI_PK PRIMARY KEY (EventID,WitnessID) 
    CONSTRAINT WI_FK1 FOREIGN KEY (EventID) REFERENCES [Event](EventID) 
    ,CONSTRAINT WI_FK2 FOREIGN KEY (WitnessID) REFERENCES [Witness] (WitnessID) 
) -- Create PropertyInvolvement Table 
DROP TABLE IF EXISTS PropertyInvolvement 
CREATE TABLE PropertyInvolvement ( 
    EventID int NOT NULL 
    ,PropertyID int NOT NULL 
    ,InvolvementType varchar(100) 
CONSTRAINT PI_PK PRIMARY KEY (EventID,PropertyID) 
CONSTRAINT PI_FK1 FOREIGN KEY (EventID) REFERENCES [Event](EventID) 
    ,CONSTRAINT PI_FK2 FOREIGN KEY (PropertyID) REFERENCES [Property] (PropertyID) 
) 