<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Confirmation_Call_Result</fullName>
        <description>Confirmation Call Result</description>
        <protected>false</protected>
        <recipients>
            <recipient>staffing@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/Event_Resource_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>Event_resource_Standby_Immediate</fullName>
        <description>Event resource - Standby Immediate</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>recruiting@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/Event_resource_Standby</template>
    </alerts>
    <alerts>
        <fullName>Immediate_Event_Resource_Reminder</fullName>
        <description>REMINDER! ADURO Biometrics Screening Event: Immediate</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/Event_Resource_Immediate_Staff_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>REMINDER_ADURO_Biometrics_Screening_Event</fullName>
        <description>REMINDER! ADURO Biometrics Screening Event- 7day</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/REMINDER_ADURO_Biometrics_Screening_Event</template>
    </alerts>
    <alerts>
        <fullName>REMINDER_ADURO_Biometrics_Screening_Event_2_day</fullName>
        <ccEmails>Health.advisor@adurolife.com</ccEmails>
        <description>REMINDER! ADURO Biometrics Screening Event: 2 day</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/REMINDER_ADURO_Biometrics_Screening_Event_2days</template>
    </alerts>
    <alerts>
        <fullName>REMINDER_ADURO_Biometrics_Screening_Event_2_dayv2</fullName>
        <description>REMINDER! ADURO Biometrics Screening Event: 2 day</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/REMINDER_ADURO_Biometrics_Screening_Event_2days</template>
    </alerts>
    <alerts>
        <fullName>REMINDER_ADURO_Biometrics_Screening_Event_7day</fullName>
        <description>REMINDER! ADURO Biometrics Screening Event- 7day</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/REMINDER_ADURO_Biometrics_Screening_Event</template>
    </alerts>
    <alerts>
        <fullName>Screener_Payment_Sent</fullName>
        <description>Screener Payment-Sent</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Finance_Templates/Screener_Payment_Sent</template>
    </alerts>
    <alerts>
        <fullName>Screener_Scheduled_Late_Payment_Sent</fullName>
        <ccEmails>amy.harris@adurolife.com</ccEmails>
        <description>Screener Scheduled Late Payment Sent</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/Screener_Scheduled_Late_Payment_Sent</template>
    </alerts>
    <fieldUpdates>
        <fullName>Attendance_Update</fullName>
        <field>Attendance__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Attendance Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_Hours_Pay_Update</fullName>
        <field>Total_Hours_Pay_AutoPop__c</field>
        <formula>Total_Hours_Pay__c</formula>
        <name>Total Hours Pay Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dead_Time</fullName>
        <description>Used on Event Resources</description>
        <field>Hidden_Dead_Time__c</field>
        <formula>Dead_Time__c</formula>
        <name>Update Dead Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>2 Day Reminder- Event Staff</fullName>
        <active>true</active>
        <criteriaItems>
            <field>WW_Event__c.Event_Status__c</field>
            <operation>equals</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>WW_Event__c.Event_Type__c</field>
            <operation>equals</operation>
            <value>Biometrics Event,Venipuncture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event_Resource__c.Event_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Goes to staff seven days prior to onsite event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>REMINDER_ADURO_Biometrics_Screening_Event_2_dayv2</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Event_Resource__c.Event_Date__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>2 Day Reminder- Standby</fullName>
        <active>false</active>
        <criteriaItems>
            <field>WW_Event__c.Event_Status__c</field>
            <operation>equals</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>WW_Event__c.Event_Type__c</field>
            <operation>equals</operation>
            <value>Biometrics Event</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event_Resource__c.Event_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event_Resource__c.Event_Role__c</field>
            <operation>equals</operation>
            <value>Stand-by</value>
        </criteriaItems>
        <description>Goes to staff seven days prior to onsite event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Event_Resource__c.Event_Date__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>7 Day Reminder- Event Staff</fullName>
        <actions>
            <name>Immediate_Event_Resource_Reminder</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WW_Event__c.Event_Status__c</field>
            <operation>equals</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>WW_Event__c.Event_Type__c</field>
            <operation>equals</operation>
            <value>Biometrics Event,Venipuncture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event_Resource__c.Event_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event_Resource__c.Event_Role__c</field>
            <operation>notEqual</operation>
            <value>Stand-by</value>
        </criteriaItems>
        <description>Goes to staff seven days prior to onsite event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>REMINDER_ADURO_Biometrics_Screening_Event_7day</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Event_Resource__c.Event_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>7 Day Reminder- Standy</fullName>
        <active>false</active>
        <criteriaItems>
            <field>WW_Event__c.Event_Status__c</field>
            <operation>equals</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>WW_Event__c.Event_Type__c</field>
            <operation>equals</operation>
            <value>Biometrics Event</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event_Resource__c.Event_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event_Resource__c.Event_Role__c</field>
            <operation>equals</operation>
            <value>Stand-by</value>
        </criteriaItems>
        <description>Goes standby staff seven days prior to onsite event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AutoPop Total Calculated Pay</fullName>
        <actions>
            <name>Total_Hours_Pay_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WW_Event__c.Event_Type__c</field>
            <operation>equals</operation>
            <value>Biometrics Event,Venipuncture</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Confirmation Call Result</fullName>
        <actions>
            <name>Confirmation_Call_Result</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Attendance_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Event_Resource__c.Confirmation_Call_Results__c</field>
            <operation>equals</operation>
            <value>Cancelled,Cancelled - Less than 24 hours notice</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Event resource- Standby Immediate</fullName>
        <actions>
            <name>Event_resource_Standby_Immediate</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WW_Event__c.Event_Status__c</field>
            <operation>equals</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>WW_Event__c.Event_Type__c</field>
            <operation>equals</operation>
            <value>Biometrics Event,Venipuncture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event_Resource__c.Event_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event_Resource__c.Event_Role__c</field>
            <operation>equals</operation>
            <value>Stand-by</value>
        </criteriaItems>
        <description>Goes to standby immediately</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Immediate Reminder- Event Staff</fullName>
        <active>false</active>
        <criteriaItems>
            <field>WW_Event__c.Event_Status__c</field>
            <operation>equals</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>WW_Event__c.Event_Type__c</field>
            <operation>equals</operation>
            <value>Biometrics Event,Venipuncture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Event_Resource__c.Event_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Goes to staff seven days prior to onsite event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Screener Late Payment-Sent</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Event_Resource__c.Paid_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This is triggered when the paid date is filled in on the Event Resource page.  It sends email notification of the payment being sent in the mail.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Screener Payment-Sent</fullName>
        <actions>
            <name>Screener_Payment_Sent</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event_Resource__c.Paid_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This is triggered when the paid date is filled in on the Event Resource page.  It sends email notification of the payment being sent in the mail.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Screener Scheduled Late Payment-Sent</fullName>
        <actions>
            <name>Screener_Scheduled_Late_Payment_Sent</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event_Resource__c.Scheduled_Pay_date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This is triggered when the paid date is filled in on the Event Resource page.  It sends email notification of the payment being sent in the mail.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
