CREATE CONSTRAINT FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT FOR (t:Team) REQUIRE t.id IS UNIQUE;
CREATE CONSTRAINT FOR (c:TeamChatSession) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT FOR (i:ChatItem) REQUIRE i.id IS UNIQUE;

LOAD CSV FROM "file:///chat_data/chat_create_team_chat.csv" AS row 
MERGE (u:User {id: toInteger(row[0])}) 
MERGE (t:Team {id: toInteger(row[1])})
MERGE (c:TeamChatSession {id: toInteger(row[2])}) 
MERGE (u)-[:CreatesSession {timeStamp: row[3]}]->(c) 
MERGE (c)-[:OwnedBy{timeStamp: row[3]}]->(t)

LOAD CSV FROM "file:///chat_data/chat_join_team_chat.csv" AS row 
MERGE (u:User {id: toInteger(row[0])}) 
MERGE (c:TeamChatSession {id: toInteger(row[1])}) 
MERGE (u)-[:Joins {timeStamp: row[2]}]->(c) 

LOAD CSV FROM "file:///chat_data/chat_leave_team_chat.csv" AS row 
MERGE (u:User {id: toInteger(row[0])}) 
MERGE (c:TeamChatSession {id: toInteger(row[1])}) 
MERGE (u)-[:Leaves {timeStamp: row[2]}]->(c) 

LOAD CSV FROM "file:///chat_data/chat_item_team_chat.csv" AS row 
MERGE (u:User {id: toInteger(row[0])}) 
MERGE (c:TeamChatSession {id: toInteger(row[1])}) 
MERGE (i:ChatItem {id: toInteger(row[2])})
MERGE (u)-[:CreateChat {timeStamp: row[3]}]->(i)
MERGE (i)-[:PartOf {timeStamp: row[3]}]->(c) 

LOAD CSV FROM "file:///chat_data/chat_mention_team_chat.csv" AS row 
MERGE (i:ChatItem {id: toInteger(row[0])})
MERGE (u:User {id: toInteger(row[1])}) 
MERGE (i)-[:Mentioned {timeStamp: row[2]}]->(u)

LOAD CSV FROM "file:///chat_data/chat_respond_team_chat.csv" AS row 
MERGE (i:ChatItem {id: toInteger(row[0])})
MERGE (j:ChatItem {id: toInteger(row[1])}) 
MERGE (i)-[:ResponseTo {timeStamp: row[2]}]->(j)
