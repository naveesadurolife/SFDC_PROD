<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Back_Out_Email_NoShow_Email_to_CFO</fullName>
        <description>Back Out Email-NoShow Email to CFO</description>
        <protected>false</protected>
        <recipients>
            <recipient>carolyn.thayer@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Vendor_Templates/Backed_Out_No_Show</template>
    </alerts>
    <alerts>
        <fullName>Email_to_HR_notifying_them_of_Workshop_in_3_days</fullName>
        <description>Email to HR notifying them of Workshop in 3 days</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>laney.schorp@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Vendor_Templates/HR_Reminder_of_Workshop</template>
    </alerts>
    <alerts>
        <fullName>Paid_Date_is_Blank</fullName>
        <ccEmails>healthfairs@adurolife.com</ccEmails>
        <description>Paid Date is Blank</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Vendor_Templates/Not_Paid_1_day_before_email</template>
    </alerts>
    <alerts>
        <fullName>Send_Event_Reminder_to_Vendor</fullName>
        <description>Send Event Reminder to Vendor</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>laney.schorp@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Vendor_Templates/Vendor_Reminder_Email_v3</template>
    </alerts>
    <alerts>
        <fullName>X72_Hour_Vendor_Reminder_Email</fullName>
        <description>72 Hour Vendor Reminder Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>laney.schorp@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Vendor_Templates/Vendor_Reminder_Email_v2</template>
    </alerts>
    <rules>
        <fullName>HF-Backed Out-No Show</fullName>
        <actions>
            <name>Back_Out_Email_NoShow_Email_to_CFO</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Billing_Changes_A_Vendor_has_back_out_or_no_showed</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event_Vendor__c.Backed_Out__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Backed Out field equalsTrue then SF sends an email to CFO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HF-Remind Vendor of the HF in 3 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Event_Vendor__c.Confirmed_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Event_Vendor__c.Vendor_Contact_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WW_Event__c.Event_Type__c</field>
            <operation>equals</operation>
            <value>Health Fair</value>
        </criteriaItems>
        <description>Confirmed Date not equal to null and Vendor Contact Email not equal to null and Event Type equals Health Fair, then SF sends a reminder email to the Vendor with details of the event.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Event_Reminder_to_Vendor</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Event_Vendor__c.Event_Date__c</offsetFromField>
            <timeLength>-72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Event_Vendor__c.Event_Date__c</offsetFromField>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Remind HR of Workshop</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Event_Vendor__c.Confirmed_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Event_Vendor__c.Vendor_Contact_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WW_Event__c.Event_Type__c</field>
            <operation>equals</operation>
            <value>Workshop</value>
        </criteriaItems>
        <description>This remindes the HR of the Workshop that is being given in 3 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_to_HR_notifying_them_of_Workshop_in_3_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Event_Vendor__c.Event_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Unpaid - 1 day before event</fullName>
        <actions>
            <name>Paid_Date_is_Blank</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event_Vendor__c.Paid_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WW_Event__c.Event_Type__c</field>
            <operation>equals</operation>
            <value>Health Fair</value>
        </criteriaItems>
        <description>this sends an email when the paid date is blank, one day before the event.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Event_Vendor__c.Event_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Billing_Changes_A_Vendor_has_back_out_or_no_showed</fullName>
        <assignedTo>carolyn.thayer@adurolife.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Change your billing invoice accordingly for the vendor that either backed out or no-showed at one of our health fairs.  The Health this pertains to can be found in the email sent to you the same time this task was assigned to you.</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Billing Changes:  A Vendor has back out or no showed</subject>
    </tasks>
</Workflow>
