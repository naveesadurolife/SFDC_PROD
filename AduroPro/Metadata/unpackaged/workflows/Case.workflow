<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Amruta_s_case_response_notification</fullName>
        <description>Amruta&apos;s case response notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>christina.stokes@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Amruta_s_case_response_notification2</fullName>
        <description>Amruta&apos;s case response notification2</description>
        <protected>false</protected>
        <recipients>
            <recipient>christina.stokes@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Closed_Email</fullName>
        <description>Case Closed Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Completion_Email</template>
    </alerts>
    <alerts>
        <fullName>Case_Notification</fullName>
        <ccEmails>jenn.deering@adurolife.com</ccEmails>
        <description>Case Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Notification_C</fullName>
        <ccEmails>Chris.Thomas@adurolife.com</ccEmails>
        <description>Case Notification- Chris Thompson</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Notification_Chris_Thompson</fullName>
        <ccEmails>Chris.Thomas@adurolife.com</ccEmails>
        <description>Case Notification- Chris Thompson</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Casey_s_case_response_notification_2</fullName>
        <description>Casey&apos;s case response notification (2)</description>
        <protected>false</protected>
        <recipients>
            <recipient>casey.mcauliff@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Danny_s_case_response_notification</fullName>
        <ccEmails>danny.peck@adurolife.com</ccEmails>
        <description>Danny&apos;s case response notificatoin</description>
        <protected>false</protected>
        <recipients>
            <recipient>danny.peck@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Danny_s_case_response_notificatoin</fullName>
        <description>Danny&apos;s case response notificatoin</description>
        <protected>false</protected>
        <recipients>
            <recipient>danny.peck@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Escalate_to_TWB_Email</fullName>
        <description>Escalate to TWB Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Partner_TWB</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/TWB_Escalation</template>
    </alerts>
    <alerts>
        <fullName>Escalation_CS_New</fullName>
        <description>Escalation - CS - New</description>
        <protected>false</protected>
        <recipients>
            <recipient>eric.hatzenbuehler@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Templates/New_Escalation_CS</template>
    </alerts>
    <alerts>
        <fullName>Help_Desk_Case_Open_3_Days</fullName>
        <description>Help Desk Case - Open 3+ Days</description>
        <protected>false</protected>
        <recipients>
            <recipient>jason.knutson@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mark.thompson@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Templates/Help_Desk_3_Days_Overdue</template>
    </alerts>
    <alerts>
        <fullName>Helpdesk_Email_to_System_Admin</fullName>
        <description>Helpdesk Email to System Admin</description>
        <protected>false</protected>
        <recipients>
            <recipient>jason.knutson@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mark.thompson@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/New_Help_Desk_Case</template>
    </alerts>
    <alerts>
        <fullName>James_Watanabe_s_case_response_notification</fullName>
        <description>James Watanabe&apos;s case response notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>james.watanabe@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Jason_Luu_s_case_response</fullName>
        <description>Jason&apos;s case response notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jason.luu@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Jess_Y_case_response_notificatoin</fullName>
        <description>Jess&apos;s case response notificatoin</description>
        <protected>false</protected>
        <recipients>
            <recipient>jessica.yockel@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Jess_s_case_response_notificatoin</fullName>
        <description>Jess&apos;s case response notificatoin</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jessica.yockel@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Jessica_M_case_response_notificatoin</fullName>
        <description>Jessica&apos;s case response notificatoin</description>
        <protected>false</protected>
        <recipients>
            <recipient>jessica.mezger@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Jessica_s_case_response_notificatoin</fullName>
        <description>Jessica&apos;s case response notificatoin</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jessica.mezger@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Leah_s_case_response_notificatoin</fullName>
        <description>Leah&apos;s case response notificatoin</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>leah.groos@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Limeade_Escalation_Alert</fullName>
        <ccEmails>alex.akita@limeade.com,mary.pigatti@limeade.com,support@limeade.com</ccEmails>
        <description>Limeade Escalation Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>darren.white@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/ADUROAM_Escalation</template>
    </alerts>
    <alerts>
        <fullName>Mike_s_Case_Response_Notification</fullName>
        <description>Mike&apos;s Case Response Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>james.watanabe@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Partner_Support_New_Case_Alert</fullName>
        <description>Partner Support - New Case Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>christina.stokes@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Account_Management/Partner_Support_New_Case</template>
    </alerts>
    <alerts>
        <fullName>Paul_s_email_notification</fullName>
        <description>Paul&apos;s email notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>paul.shinoda@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Serena_Challenge_Request</fullName>
        <ccEmails>christinas@worksitewellness.net</ccEmails>
        <description>Serena Challenge Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>biometrics@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>kaycee@worksitewellness.net</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Templates/New_Challenge_Suggestions</template>
    </alerts>
    <alerts>
        <fullName>Shaun_H_s_case_notification</fullName>
        <description>Shaun H&apos;s case notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shaun.huntington@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>TWB_Escalation_Alert</fullName>
        <ccEmails>renee.davis@employeetotalwellbeing.com</ccEmails>
        <description>TWB Escalation Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>darren.white@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/TWB_Escalation</template>
    </alerts>
    <alerts>
        <fullName>Test_Support_Case_Closed_complete_survey</fullName>
        <description>Test: Support Case Closed complete survey</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Templates/Test_Support_Closed_Template</template>
    </alerts>
    <alerts>
        <fullName>Trudy_s_case_response_notification</fullName>
        <description>Trudy&apos;s case response notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>trudy.haley@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Trudy_s_case_response_notificatoin</fullName>
        <description>Trudy&apos;s case response notificatoin</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>trudy.haley@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Case_Reply_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Case_Status_to_Closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Case Status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Type_Field_Update</fullName>
        <field>Type</field>
        <literalValue>Smoking</literalValue>
        <name>Case Type Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_status_to_new</fullName>
        <description>change case status to new when a response is received</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Change status to new</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Reply_on_Case</fullName>
        <description>Update status to new when a reply is received</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>New Reply on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_case_reply_received</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>New case reply received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Response_Received_on_Case</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Response Received on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Viewable_by_Portal</fullName>
        <field>Portal_Cases__c</field>
        <literalValue>1</literalValue>
        <name>Viewable by Portal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>autoresponder_case_close</fullName>
        <description>closes cases that are autoresponders instead of putting them in a queue</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>autoresponder case close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Amruta Case Reply 1</fullName>
        <actions>
            <name>Amruta_s_case_response_notification2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Amruta Vyas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Amruta Vyas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Partner Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Auto Close-auto responders</fullName>
        <actions>
            <name>Case_Status_to_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>autoresponse,out of office,autoresponder,vacation</value>
        </criteriaItems>
        <description>This closes cases that are opened due to an auto responder</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Autorseponder Case Close</fullName>
        <actions>
            <name>autoresponder_case_close</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>out of office,autoresponder,autoresponse,auto response,undeliverable,Out of Office AutoReply,Out of Office,Auto,Out of The Office</value>
        </criteriaItems>
        <description>Closes cases with keywords out of office,autoresponder,autoresponse,auto response in subject</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Banking a Solution for Partner Portal</fullName>
        <actions>
            <name>Bank_a_Solution_for_Partner_Portal</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsSelfServiceClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This sends a message to our support team once a case is closed in order for us to bank the solution for them.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Completion Email</fullName>
        <actions>
            <name>Case_Closed_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Casey Case Reply 1</fullName>
        <actions>
            <name>Casey_s_case_response_notification_2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Casey McAuliff</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Casey McAuliff</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Challenge Requests</fullName>
        <actions>
            <name>Serena_Challenge_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>Suggestion</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Challenge Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>equals</operation>
            <value>Serena</value>
        </criteriaItems>
        <description>This workflow allows for account managers to view challenge requests on a weekly basis</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Chris Thomas Case Reply Notification</fullName>
        <actions>
            <name>Case_Notification_Chris_Thompson</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Chris Thomas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress,New</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Danny%27s Case Reply 1</fullName>
        <actions>
            <name>Danny_s_case_response_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Danny Peck</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Danny Peck</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Dee Case Reply 1</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Dee Davis</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.LastModifiedById</field>
            <operation>equals</operation>
            <value>Dee Davis</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Dee Case Reply Notification</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Dee Davis</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress,New</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Escalation to TWB</fullName>
        <actions>
            <name>Escalate_to_TWB_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalate to Total Wellbeing</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Escalation- CS - New Case</fullName>
        <actions>
            <name>Escalation_CS_New</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Escalation - Client Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Help Desk Case - Open 3%2B Days</fullName>
        <actions>
            <name>Help_Desk_Case_Open_3_Days</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>HelpDesk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Helpdesk Support - New Case</fullName>
        <actions>
            <name>Helpdesk_Email_to_System_Admin</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>HelpDesk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>James W Case Reply 1</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>James Watanabe</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>James Watanabe</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Jason L%27s Case Reply 1</fullName>
        <actions>
            <name>Jason_Luu_s_case_response</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Jason Luu</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Jason Luu</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Jennifer Deering Case Reply Notification</fullName>
        <actions>
            <name>Case_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Jenn Deering</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress,New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Jenn Deering</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Jess Case Reply 1</fullName>
        <actions>
            <name>Jess_Y_case_response_notificatoin</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Jessica Yockel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Jessica Yockel</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Jessica Case Reply 1</fullName>
        <actions>
            <name>Jessica_M_case_response_notificatoin</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Jessica Mezger</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Jessica Mezger</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kohls- Type Field Update</fullName>
        <actions>
            <name>Case_Type_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Tobacco-Email</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Leah Case Reply 1</fullName>
        <actions>
            <name>Leah_s_case_response_notificatoin</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Response_Received_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Leah Groos</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Leah Groos</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Limeade Escalation Rule</fullName>
        <actions>
            <name>Limeade_Escalation_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated to Limeade</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Mike%27s Case Reply 1</fullName>
        <actions>
            <name>Mike_s_Case_Response_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Michael Weiland</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Michael Weiland,Mike Weiland</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Data Support</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Partner Support - New Case</fullName>
        <actions>
            <name>Partner_Support_New_Case_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Partner Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Paul Case Reply 1</fullName>
        <actions>
            <name>Paul_s_email_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Paul Shinoda</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Paul Shinoda</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Shaun Case Reply 1</fullName>
        <actions>
            <name>Shaun_H_s_case_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Shaun Huntington</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Shaun Huntington</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TWB Escalation</fullName>
        <actions>
            <name>TWB_Escalation_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalate to Total Wellbeing</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Test</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Test%3A Support Case Closed</fullName>
        <actions>
            <name>Test_Support_Case_Closed_complete_survey</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Send_Satisfaction_Survey__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email,Phone</value>
        </criteriaItems>
        <description>this is a test of the support closed survey</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Trudy Case Reply 1</fullName>
        <actions>
            <name>Trudy_s_case_response_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Owner__c</field>
            <operation>equals</operation>
            <value>Trudy Haley</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Escalated to Limeade,Closed,New,In Progress,Waiting for member response,Close in 72 hours</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Trudy Haley</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Viewable by Portal</fullName>
        <actions>
            <name>Viewable_by_Portal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated to Limeade,Escalate to Total Wellbeing</value>
        </criteriaItems>
        <description>If the the case get escalated to a portal user, this will check a box that allows the case to be viewable by the portal user if the case is closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Bank_a_Solution_for_Partner_Portal</fullName>
        <assignedTo>healthadvisor@worksitewellness.net</assignedTo>
        <assignedToType>user</assignedToType>
        <description>There has been a case that our partner portal closed.  Please check the case and see if any comments were posted to the case.  If there were, bank them as solutions as quick as possible by copy and pasting them as a new solution.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Bank a Solution for Partner Portal</subject>
    </tasks>
</Workflow>
