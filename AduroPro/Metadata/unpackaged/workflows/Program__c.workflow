<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Coaching_Start_Date_Notication</fullName>
        <ccEmails>toni.best@adurolife.com</ccEmails>
        <description>Coaching Start Date Notication</description>
        <protected>false</protected>
        <recipients>
            <recipient>kaycee.spitler@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Coaching_Templates/Coaching_Start_Date_Notification</template>
    </alerts>
    <alerts>
        <fullName>Contract_Renewal_Alert_180_days</fullName>
        <description>Contract Renewal Alert 180 days</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Director_Primary__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Account_Management/Contract_Renewal</template>
    </alerts>
    <alerts>
        <fullName>Contract_Renewal_Alert_30_days</fullName>
        <description>Contract Renewal Alert 30 days</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Director_Primary__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Account_Management/Contract_Renewal</template>
    </alerts>
    <alerts>
        <fullName>Contract_Renewal_Alert_60_days</fullName>
        <description>Contract Renewal Alert 60 days</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Director_Primary__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Account_Management/Contract_Renewal</template>
    </alerts>
    <alerts>
        <fullName>Contract_Renewal_Alert_90_days</fullName>
        <description>Contract Renewal Alert 90 days</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Director_Primary__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Account_Management/Contract_Renewal</template>
    </alerts>
    <alerts>
        <fullName>End_Date_Notification</fullName>
        <ccEmails>dee.davis@adurolife.com</ccEmails>
        <description>End Date Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Program_E_mail_Templates/Program_End_Date_Notification</template>
    </alerts>
    <alerts>
        <fullName>Program_Account_Mgr_Change_Notification</fullName>
        <ccEmails>dee.davis@adurolife.com</ccEmails>
        <description>Program Account Mgr Change Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Program_E_mail_Templates/Program_Account_Manager_Change_Notification</template>
    </alerts>
    <alerts>
        <fullName>Program_Status_Change_Notification</fullName>
        <ccEmails>dee.davis@adurolife.com</ccEmails>
        <description>Program Status Change Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Program_E_mail_Templates/Program_Status_Notification</template>
    </alerts>
    <alerts>
        <fullName>Program_name_Change</fullName>
        <ccEmails>dee.davis@adurolife.com</ccEmails>
        <description>Program name Change</description>
        <protected>false</protected>
        <recipients>
            <recipient>biometrics@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Program_E_mail_Templates/Program_Name_Change_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_New_Program_Form_to_HA_Labs</fullName>
        <ccEmails>bgodsey@homeaccess.com, drwhite@worksitewellness.net</ccEmails>
        <description>Send New Program Form to HA Labs</description>
        <protected>false</protected>
        <recipients>
            <field>Program_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Program_E_mail_Templates/HA_Labs_New_Program_Email</template>
    </alerts>
    <alerts>
        <fullName>Start_Date_Changes</fullName>
        <ccEmails>dee.davis@adurolife.com</ccEmails>
        <description>Start Date Changes</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Program_E_mail_Templates/Program_Start_Date_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Director</fullName>
        <field>Account_Director_Active_Program__c</field>
        <formula>Account_Director_Primary__r.FirstName + &apos; &apos; +  Account_Director_Primary__r.LastName</formula>
        <name>Account Director</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Ownership</fullName>
        <field>Account_Ownership__c</field>
        <formula>TEXT(Program_Type__c)</formula>
        <name>Account Ownership</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Ownership_Acct_Page</fullName>
        <field>Account_Ownership__c</field>
        <formula>&quot;Program_Type__c&quot;</formula>
        <name>Account Ownership- Acct Page</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mark_Program_Completed</fullName>
        <description>Marks the Program Status completed one day after the Program End Date.</description>
        <field>Program_Status__c</field>
        <literalValue>Complete</literalValue>
        <name>Mark Program Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Director</fullName>
        <actions>
            <name>Account_Director</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program__c.Program_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Ownership</fullName>
        <actions>
            <name>Account_Ownership</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program__c.Program_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Activate Program - HTK options</fullName>
        <actions>
            <name>Send_New_Program_Form_to_HA_Labs</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program__c.Program_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Include_HTK_Component__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow initiates actions that should occur when a program is &quot;Activated&quot;  and includes HTK options, such as e-mailing the &quot;New Program&quot; form e-mail to HA Labs.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Auto update Ready to Ship</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Program__c.Shipping_Approval_Needed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Coaching Start Date Notification</fullName>
        <actions>
            <name>Coaching_Start_Date_Notication</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program__c.Program_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Wellmetrics_Coaching_Component__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Renewal</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Program__c.Contract_Renewal_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Program_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Contract_Renewal_Alert_180_days</name>
                <type>Alert</type>
            </actions>
            <timeLength>-180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Contract_Renewal_Alert_90_days</name>
                <type>Alert</type>
            </actions>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Contract_Renewal_Alert_30_days</name>
                <type>Alert</type>
            </actions>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Contract_Renewal_Alert_60_days</name>
                <type>Alert</type>
            </actions>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Follow up to schedule Biometric Screening</fullName>
        <actions>
            <name>Schedule_Next_Year_s_Biometrics</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Program__c.Program_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Account_Manager__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Follow up with</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Program__c.Include_Onsite_component__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>KYN-Phys Fax Form</fullName>
        <actions>
            <name>KYN_Task</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program__c.Activity_Device_Note_to_User__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mark Program Complete after End Date</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Program__c.Program_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <description>Marks the program record status to complete one day after the end date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Mark_Program_Completed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Program__c.Program_End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Program Account Manager Change Notifications</fullName>
        <actions>
            <name>Program_Account_Mgr_Change_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(  Account_Manager__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Program End Date Notifications</fullName>
        <actions>
            <name>End_Date_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Program_End_Date__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Program Name Change</fullName>
        <active>false</active>
        <description>This notifies physician fax form processor that the name has changed.</description>
        <formula>ISCHANGED( Name )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Program Name Change Workflow</fullName>
        <actions>
            <name>Program_name_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Name )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Program STATUS Change Notifications</fullName>
        <actions>
            <name>Program_Status_Change_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Program_Status__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Program Start  Date Notifications</fullName>
        <actions>
            <name>Start_Date_Changes</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Program_Start_Date__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>KYN_Task</fullName>
        <assignedTo>leah.groos@adurolife.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>An update to the Physician Fax form has been triggered and added to your Task Report under the subject &quot;Phys Fax&quot;.  This report will will also show the Program this was assigned to and the details of the changes.</description>
        <dueDateOffset>-30</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Program__c.Limeade_Live_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>KYN-Phys Fax Form</subject>
    </tasks>
    <tasks>
        <fullName>Schedule_Next_Year_s_Biometrics</fullName>
        <assignedToType>owner</assignedToType>
        <description>This task was triggered because this program is doing onsite biometrics.</description>
        <dueDateOffset>-120</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Program__c.Program_End_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Schedule Next Year&apos;s Biometrics</subject>
    </tasks>
</Workflow>
