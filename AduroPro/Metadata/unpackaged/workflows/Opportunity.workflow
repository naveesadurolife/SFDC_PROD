<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contract_Signed</fullName>
        <ccEmails>adurocontracts@limeade.com; alex.beechen@adurolife.com</ccEmails>
        <description>Contract Signed</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Director__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Sales_Email_Templates/Contract_Signedv2</template>
    </alerts>
    <alerts>
        <fullName>Limeade_Opp_Share_Email</fullName>
        <description>Limeade Opp Share Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>emily.chu@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Email_Templates/Limeade_Opp_Share_Notification</template>
    </alerts>
    <alerts>
        <fullName>Red_Zone</fullName>
        <description>Red Zone</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
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
            <recipient>eric.hatzenbuehler@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>joshua.thomas@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>julie.anderson@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>leah.groos@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Email_Templates/Red_Zone_Opp</template>
    </alerts>
    <alerts>
        <fullName>Sales_to_Service_Email_Alert</fullName>
        <description>Sales to Service Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>christopher.pedley@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>darren.white@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account_Management/Opportunity_Won</template>
    </alerts>
    <alerts>
        <fullName>When_Limeade_Shares_an_Opportunity_with_Worksite_Wellness_this_email_is_auto_gen</fullName>
        <ccEmails>chris.dickinson@limeade.com</ccEmails>
        <description>When Limeade Shares an Opportunity with Worksite Wellness this email is auto-generated to notify 2 people within WW org.</description>
        <protected>false</protected>
        <recipients>
            <recipient>darren.white@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>laney.schorp@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account_Management/WW_Opportunity_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Coaching_Notes_update</fullName>
        <description>updates the coaching notes from sales to service</description>
        <field>Other_Notes__c</field>
        <formula>Coaching_Notes__c</formula>
        <name>Coaching Notes update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Signed_Update</fullName>
        <field>Contract_Signed__c</field>
        <literalValue>1</literalValue>
        <name>Contract Signed Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Data_Considerations_Update</fullName>
        <field>Data_Considerations__c</field>
        <formula>Data_Considerations__c</formula>
        <name>Data Considerations Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Description_update</fullName>
        <description>this updates the description on the account from opp</description>
        <field>Description</field>
        <formula>Description</formula>
        <name>Description update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Employees</fullName>
        <description>When employees are edited on the Opp, then it updates the Employees field on the Acct</description>
        <field>NumberOfEmployees</field>
        <formula>Employees__c</formula>
        <name>Employees</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Estimated_Launch</fullName>
        <field>Proposed_Launch_Date__c</field>
        <formula>Estimated_Launch__c</formula>
        <name>Estimated Launch</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Incentive_Notes_Update</fullName>
        <description>copies sales to service incentive notes</description>
        <field>Incentive_Program_Description__c</field>
        <formula>Incentive_Design__c</formula>
        <name>Incentive Notes Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Source</fullName>
        <description>This updates from opp page</description>
        <field>Lead_Source__c</field>
        <formula>Lead_Source_Formula__c</formula>
        <name>Lead Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Source_Limeade</fullName>
        <field>LeadSource</field>
        <literalValue>Limeade</literalValue>
        <name>Lead Source Limeade</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Limeade_Direct</fullName>
        <field>Type</field>
        <literalValue>Limeade Direct</literalValue>
        <name>Limeade Direct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Amount</fullName>
        <field>Opp_Amount__c</field>
        <formula>Amount</formula>
        <name>Opp Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Owner</fullName>
        <description>This autopopulates the Opp Owner</description>
        <field>Opportunity_Owner__c</field>
        <formula>CreatedBy.FirstName  + &quot; &quot; + CreatedBy.LastName</formula>
        <name>Opp Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Owner_change</fullName>
        <description>updates the opp owner on acct</description>
        <field>Opportunity_Owner__c</field>
        <formula>Owner.FirstName &amp;&quot; &quot;&amp;
 Owner.LastName</formula>
        <name>Opp Owner change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Stage_Time_Stamp</fullName>
        <field>Date_of_Stage_Change__c</field>
        <formula>TODAY()</formula>
        <name>Opp Stage Time Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previous_Program_update</fullName>
        <description>copies program notes from opportunity to accounts when closed won.</description>
        <field>Previous_Program__c</field>
        <formula>Current_Program__c</formula>
        <name>Previous Program update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Primary_Client_Contact</fullName>
        <description>This is filled in from opp page when filled in.
Primary_Client_Contact__r.FirstName + &apos; &apos; +  Primary_Client_Contact__r.LastName</description>
        <field>Primary_Client_Contact__c</field>
        <formula>Primary_Client_Contact__r.FirstName + &apos; &apos; +  Primary_Client_Contact__r.LastName</formula>
        <name>Primary Client Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Primary_Client_Contact_Email</fullName>
        <field>Primary_Client_Contact_Email__c</field>
        <formula>Primary_Client_Contact_Email__c</formula>
        <name>Primary Client Contact Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Primary_Client_Contact_Email2</fullName>
        <description>updates the primary client contact email on the account page</description>
        <field>Primary_Client_Contact_Email__c</field>
        <formula>Primary_Client_Contact_Email__c</formula>
        <name>Primary Client Contact Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Primary_Client_Contact_Phone</fullName>
        <field>Primary_Client_Phone__c</field>
        <formula>Primary_Client_Contact_Phone__c</formula>
        <name>Primary Client Contact Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Red_Zone_Opp</fullName>
        <field>Red_Zone__c</field>
        <literalValue>1</literalValue>
        <name>Red Zone Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Red_Zone_Opp_False</fullName>
        <field>Red_Zone__c</field>
        <literalValue>0</literalValue>
        <name>Red Zone Opp- False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Red_Zone_on_Acct</fullName>
        <field>Red_Zone__c</field>
        <literalValue>1</literalValue>
        <name>Red Zone on Acct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewal_Date</fullName>
        <field>Contract_Renewal_Date__c</field>
        <formula>Renewal_Date__c</formula>
        <name>Renewal Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Spouse_Dependents</fullName>
        <field>Spouse_Depenedents__c</field>
        <formula>Spouse_Depenedents__c</formula>
        <name>Spouse/Dependents</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Type_Update</fullName>
        <field>Type__c</field>
        <formula>TEXT(Type)</formula>
        <name>Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Type_field_update</fullName>
        <field>Type__c</field>
        <formula>Type_formula__c</formula>
        <name>Type field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Amount Update - Acct Page</fullName>
        <actions>
            <name>Opp_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This updates the acct page when opp page is edited.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contract Signed</fullName>
        <actions>
            <name>Contract_Signed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Contract__c</field>
            <operation>notEqual</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Signed - Opp</fullName>
        <actions>
            <name>Contract_Signed_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Contract__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Description update</fullName>
        <actions>
            <name>Description_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Description</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This populates the from the Description field on the Opp</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Employees</fullName>
        <actions>
            <name>Employees</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Employees__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Estimated Launch</fullName>
        <actions>
            <name>Estimated_Launch</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Estimated_Launch__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Industry Field Update</fullName>
        <actions>
            <name>Type_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Source</fullName>
        <actions>
            <name>Lead_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Lead_Source_Formula__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This updates the lead source on the account page with what is filled out on the opp page.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Limeade Opp Shared</fullName>
        <actions>
            <name>Limeade_Opp_Share_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Lead_Source_Limeade</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Limeade_Direct</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Created_By__c</field>
            <operation>contains</operation>
            <value>Connection User</value>
        </criteriaItems>
        <description>Limeade Shared an Opp</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Client Notification</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>This sends a message to ADURO Finance, Sales and Service Teams and Chris, Mary and Martin at Limeade that an opportunity has been closed won.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Opp Transfer Task Alert</fullName>
        <actions>
            <name>Action_Item_Send_Follow_Up_Email</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Alerts the new opportunity owner to follow up each time owner is changed.</description>
        <formula>ISCHANGED( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opp Owner Change%3A Task Alert</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>TRUE</value>
        </criteriaItems>
        <description>Alerts the new opportunity owner to follow up each time owner is changed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opp Owner change</fullName>
        <actions>
            <name>Opp_Owner_change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>updates the opp owner on acct page</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Primary Client Contact</fullName>
        <actions>
            <name>Primary_Client_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Primary_Client_Contact_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This is the contract during the sales process.  This is pulled from the opp page when updated on opp.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Primary Client Contact Email</fullName>
        <actions>
            <name>Primary_Client_Contact_Email2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Primary_Client_Contact_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updates the Email on the Acct Page</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Primary Client Contact Phone</fullName>
        <actions>
            <name>Primary_Client_Contact_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Primary_Client_Contact_Phone__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Red Zone</fullName>
        <actions>
            <name>Red_Zone_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Red_Zone__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Red Zone - uncheck Acct</fullName>
        <actions>
            <name>Red_Zone_Opp_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Red_Zone__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Red Zone Opp</fullName>
        <actions>
            <name>Red_Zone</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Red_Zone__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Renewal Date</fullName>
        <actions>
            <name>Renewal_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Renewal_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales to Service</fullName>
        <actions>
            <name>Sales_to_Service_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Coaching_Notes_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Data_Considerations_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Incentive_Notes_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Previous_Program_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won,3: Finalist,4: Verbal Award</value>
        </criteriaItems>
        <description>Sales to Service Email Alert
Field Update	Incentive Notes Update
Field Update	Coaching Notes update
Field Update	Data Considerations Update
Field Update	Previous Program update</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Spouse%2FDependents</fullName>
        <actions>
            <name>Spouse_Dependents</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Spouse_Depenedents__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Stage Time Change</fullName>
        <actions>
            <name>Opp_Stage_Time_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(
 ISNEW() ,
ISCHANGED(StageName)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WW Opp Notification</fullName>
        <actions>
            <name>When_Limeade_Shares_an_Opportunity_with_Worksite_Wellness_this_email_is_auto_gen</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Share_with_WW__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Notifies WW when Limeade Shares an Opp within our Portal.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Action_Item_Send_Follow_Up_Email</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Action Item: Send Follow Up Email</subject>
    </tasks>
    <tasks>
        <fullName>Opportunity_Closed_Won_Schedule_an_Implementation_Meeting</fullName>
        <assignedToType>accountOwner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Opportunity Closed-Won.  Schedule an Implementation Meeting</subject>
    </tasks>
    <tasks>
        <fullName>Opportunity_Won_Bill_the_Client</fullName>
        <assignedTo>carolyn.thayer@adurolife.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Opportunity Won-Bill the Client</subject>
    </tasks>
</Workflow>
