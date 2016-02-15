<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Acct_Created_by_Connection_User</fullName>
        <description>Acct Created by Connection User</description>
        <protected>false</protected>
        <recipients>
            <recipient>emily.chu@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mark.thompson@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account_Management/Acct_Created_by_Conn_User</template>
    </alerts>
    <alerts>
        <fullName>Alert_Coaches_of_New_Client_Launch</fullName>
        <description>Alert Coaches of New Client Launch</description>
        <protected>false</protected>
        <recipients>
            <recipient>biometrics@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>carolyn.thayer@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>connie.odonnell@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>darren.white@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>laney.schorp@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>leah.groos@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Coaching_Templates/New_Coaching_Client_Being_Launched</template>
    </alerts>
    <alerts>
        <fullName>Contract_Signed_Email_Alert</fullName>
        <ccEmails>jason.knutson@adurolife.com</ccEmails>
        <description>Contract Signed Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>scott.durbin@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Contract_Signed_temp</template>
    </alerts>
    <alerts>
        <fullName>LOI_Signed</fullName>
        <ccEmails>sales@adurolife.com</ccEmails>
        <description>LOI Signed</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>christopher.pedley@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account_Management/LOI_Signed</template>
    </alerts>
    <alerts>
        <fullName>Set_Up_Fee_Received</fullName>
        <ccEmails>sales@adurolife.com</ccEmails>
        <description>Set Up Fee Received</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account_Management/Set_Up_Fee_Received</template>
    </alerts>
    <alerts>
        <fullName>Signed_Contract</fullName>
        <ccEmails>sales@adurolife.com</ccEmails>
        <description>Signed Contract</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>alex.beechen@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account_Management/Contract_Signed</template>
    </alerts>
    <fieldUpdates>
        <fullName>Connections_Acct</fullName>
        <field>Connections_Account__c</field>
        <literalValue>1</literalValue>
        <name>Connections Acct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Monthly_Status_Update</fullName>
        <description>Reminder to update &quot;Monthly Status Update&quot; under Accounts</description>
        <field>Monthly_Status_Update__c</field>
        <name>Monthly Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Vendor_Status_to_Active</fullName>
        <field>Vendor_Status__c</field>
        <literalValue>Active</literalValue>
        <name>Set Vendor Status to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Accounts Created- by Conn User</fullName>
        <actions>
            <name>Acct_Created_by_Connection_User</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.CreatedById</field>
            <operation>contains</operation>
            <value>connection</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Alert Coaches of New Client</fullName>
        <actions>
            <name>Alert_Coaches_of_New_Client_Launch</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Alert_Coaches_of_New_Client_Launch__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Account.Coaching_Go_Live_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Contact to Program</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>equals</operation>
            <value>Kohl&apos;s</value>
        </criteriaItems>
        <description>If a Kohl&apos;s contact is created then the contact is automatically imported into the Kohl&apos;s 2013 program</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contract Signed</fullName>
        <actions>
            <name>Signed_Contract</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LOI Signed</fullName>
        <actions>
            <name>LOI_Signed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.LOI_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC Test</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Up Fee Received</fullName>
        <actions>
            <name>Set_Up_Fee_Received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Set_Up_Fee_Received__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Vendor Status to Active</fullName>
        <actions>
            <name>Set_Vendor_Status_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Vendor_Ins_Accepted__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If Ins Accepted, set Vendor Status to Active</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SignedContractEmailRule</fullName>
        <actions>
            <name>Contract_Signed_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When the contract signed box is check this rule will activate</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Discovery Workshop Date</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Discovery_Meeting_Completed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Buy_Client_Domain_and_Redirect_WellMetric_Domain_to_Client_Domain</fullName>
        <assignedTo>leah.groos@adurolife.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>-30</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Proposed_Launch_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Buy Client Domain and Redirect WellMetric Domain to Client Domain</subject>
    </tasks>
    <tasks>
        <fullName>Client_Approval_of_Website_Completed</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-30</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Proposed_Launch_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Client Approval of Website Completed</subject>
    </tasks>
    <tasks>
        <fullName>Client_Completed_Implementation_Checklist</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>14</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Client Completed &quot;Implementation Checklist&quot;</subject>
    </tasks>
    <tasks>
        <fullName>Clients_Approval_of_Website_Completed</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-30</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Proposed_Launch_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Client Approval of Website Completed</subject>
    </tasks>
    <tasks>
        <fullName>Configure_online_services_inside_of_Limeade</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-15</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Proposed_Launch_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Configure online services inside of Limeade</subject>
    </tasks>
    <tasks>
        <fullName>Create_Account_on_Limeade</fullName>
        <assignedTo>darren.white@adurolife.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>-60</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Proposed_Launch_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Create Account on Limeade</subject>
    </tasks>
    <tasks>
        <fullName>Design_New_Client_Communication_Toolbox</fullName>
        <assignedTo>connie.odonnell@adurolife.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Consult the Account Rep to see details about this Account and what they want.</description>
        <dueDateOffset>-65</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Proposed_Launch_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Design New Client Communication Toolbox</subject>
    </tasks>
    <tasks>
        <fullName>Launch_Communication_Toolbox_to_Client</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-60</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Proposed_Launch_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Launch Communication Toolbox to Client</subject>
    </tasks>
    <tasks>
        <fullName>Launch_Program</fullName>
        <assignedToType>owner</assignedToType>
        <description>To do this you need to bulk upload to automatically launch invitation emails.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Proposed_Launch_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Launch Program</subject>
    </tasks>
    <tasks>
        <fullName>Load_Key_Vendor_Contact_Info_in_the_Accounts_Tab</fullName>
        <assignedToType>owner</assignedToType>
        <description>Examples are EAP&apos;s, Brokers, Smoking Cessation Vendors, other onsite vendors etc.</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Load Key Vendor Contact Info in the Accounts Tab</subject>
    </tasks>
    <tasks>
        <fullName>Pre_Launch_Email_sent_From_Leadership_to_announce_program_and_what_to_expect</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-60</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Proposed_Launch_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Pre-Launch Email sent From Leadership to announce program and what to expect.</subject>
    </tasks>
    <tasks>
        <fullName>Schedule_Implementation_Meeting</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Schedule Implementation Meeting</subject>
    </tasks>
    <tasks>
        <fullName>Send_Client_Checklist</fullName>
        <assignedToType>owner</assignedToType>
        <description>This is in DropBox under &quot;Implementation Documentation&quot;.  It is called &quot;Implementation Form for New Client&quot;</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Send Client Checklist</subject>
    </tasks>
    <tasks>
        <fullName>Send_Limeade_New_Client_Launch_Announcement</fullName>
        <assignedToType>owner</assignedToType>
        <description>Notify an Support Lead at Limeade (ex: Alex Akita).</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Send Limeade New Client Launch Announcement</subject>
    </tasks>
    <tasks>
        <fullName>Upload_Client_Eligibility_List</fullName>
        <assignedToType>owner</assignedToType>
        <description>This can be retrieved from the HR team, Broker, or whomever is your primary contact for this account.</description>
        <dueDateOffset>-30</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Proposed_Launch_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Upload Client Eligibility List</subject>
    </tasks>
    <tasks>
        <fullName>Whitelist_Worksite_Wellness_and_Limeade</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-60</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Proposed_Launch_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Whitelist Worksite Wellness and Limeade</subject>
    </tasks>
    <tasks>
        <fullName>Whitelists_Worksite_Wellness_and_Limeade</fullName>
        <assignedToType>owner</assignedToType>
        <description>See file in DropBox under &quot;Implementation Documentation&quot; Folder called &quot;IT Instructions Limeade&quot;</description>
        <dueDateOffset>-60</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Proposed_Launch_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Whitelist Worksite Wellness and Limeade</subject>
    </tasks>
</Workflow>
