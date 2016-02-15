<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Activity_Device_Submitted</fullName>
        <description>Activity Device Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Activity_Device_Submitted_Template</template>
    </alerts>
    <alerts>
        <fullName>Activity_Device_Submitted_ESI</fullName>
        <description>Activity Device Submitted-ESI</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Order_Email_Templates/Activity_Device_Submitted_ESI</template>
    </alerts>
    <alerts>
        <fullName>Activity_Device_Submitted_Email_Nelnet</fullName>
        <description>Activity Device Submitted Email-Nelnet</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Activity_Device_Submitted_Template_Nelnet</template>
    </alerts>
    <alerts>
        <fullName>Activity_Device_Submitted_Email_REI</fullName>
        <description>Activity Device Submitted Email-REI</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Order_Email_Templates/Order_Submitted_Activity_Device_REI</template>
    </alerts>
    <alerts>
        <fullName>Activity_Device_Submitted_Email_Vulcan</fullName>
        <description>Activity Device Submitted Email-Vulcan</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Templates/Order_Submitted_Activity_Device_Vulcan_Vibe</template>
    </alerts>
    <alerts>
        <fullName>CCHMC_No_Pass</fullName>
        <ccEmails>Mark.thompson@adurolife.com; shawn.geddes@adurolife.com</ccEmails>
        <description>CCHMC- No Pass</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/CCHMC_No_Passing</template>
    </alerts>
    <alerts>
        <fullName>Cancelled_orderv2</fullName>
        <ccEmails>dee.davis@adurolife.com</ccEmails>
        <description>Cancelled order</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Order_Email_Templates/Cancelled_Orders</template>
    </alerts>
    <alerts>
        <fullName>Dee_s_Order_Notification</fullName>
        <ccEmails>Dee.davis@adurolife.com</ccEmails>
        <description>Dee&apos;s Order Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>healthadvisor@worksitewellness.net</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Order_Email_Templates/Dee_Order_Notification</template>
    </alerts>
    <alerts>
        <fullName>Home_Test_Kit_30_Day_Check_In</fullName>
        <description>Home Test Kit 30 Day Check In</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Order_Email_Templates/Home_Test_Kit_30_Day_Check_In</template>
    </alerts>
    <alerts>
        <fullName>Home_Test_Kit_Order_Check_In</fullName>
        <description>Home Test Kit Order Check In</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Order_Email_Templates/Home_Test_Kit_Order_Check_In_Template</template>
    </alerts>
    <alerts>
        <fullName>Home_Test_Kit_Order_Duplicate</fullName>
        <description>Home Test Kit Order Duplicate</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Order_Email_Templates/Home_Test_Kit_Order_Duplicate_Template</template>
    </alerts>
    <alerts>
        <fullName>Home_Test_Kit_Order_Submitted</fullName>
        <description>Home Test Kit Order Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Order_Email_Templates/Home_Test_Kit_Order_Submitted_Template</template>
    </alerts>
    <alerts>
        <fullName>Home_Test_Kit_Test_Had_Errors</fullName>
        <ccEmails>support@worksitewellness.net</ccEmails>
        <description>Home Test Kit Test Had Errors</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Order_Email_Templates/Home_Test_Kit_Test_Had_Errors_Template</template>
    </alerts>
    <alerts>
        <fullName>Kohl_s_2015_Healthy_Screening</fullName>
        <description>Kohl&apos;s 2015- Healthy Screening</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Order_Email_Templates/Kohl_s_Healthy_Range_Draft1</template>
    </alerts>
    <alerts>
        <fullName>Kohl_s_2015_Unhealthy_Screening</fullName>
        <description>Kohl&apos;s 2015- Unhealthy Screening</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Order_Email_Templates/Kohl_s_Unhealthy_Ranges_Draft</template>
    </alerts>
    <alerts>
        <fullName>Kohl_s_Associate_Post_Event_Survey</fullName>
        <description>Kohl&apos;s Associate Post Event Survey</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/Kohls_Associate_Kohl_s_Associate_Health_Screening</template>
    </alerts>
    <alerts>
        <fullName>Kohl_s_Dependents_Address_Stress</fullName>
        <description>Kohl&apos;s Dependents-Address Stress</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Kohl_s_Dependents_Address_the_Stress</template>
    </alerts>
    <alerts>
        <fullName>Kohl_s_Dependents_Nutrition</fullName>
        <description>Kohl&apos;s Dependents - Nutrition</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Kohl_s_Dependents_Mission_Nutrition</template>
    </alerts>
    <alerts>
        <fullName>Kohl_s_Email_Blood_Pressure_Fail</fullName>
        <description>Kohl&apos;s Email - Blood Pressure Fail</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Kohl_s_Address_the_Stress</template>
    </alerts>
    <alerts>
        <fullName>Kohl_s_Email_Cholesterol_or_Glucose_Fail</fullName>
        <description>Kohl&apos;s Email - Cholesterol or Glucose Fail</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Kohl_s_Mission_Nutrition</template>
    </alerts>
    <alerts>
        <fullName>Kohl_s_Missing_Data_2015</fullName>
        <description>Kohl&apos;s Missing Data-2015</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Order_Email_Templates/Kohl_s_missing_data</template>
    </alerts>
    <alerts>
        <fullName>Kohl_s_Post_Event_Survey</fullName>
        <description>Kohl&apos;s Post Event Survey</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/Kohls_Associate_Kohl_s_Associate_Health_Screening</template>
    </alerts>
    <alerts>
        <fullName>Kohls_Dependents_BMI_Failed_Wt_Loss</fullName>
        <description>Kohls Dependents- BMI Failed/Wt Loss</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Kohl_s_Dependents_Weight_Loss_Program</template>
    </alerts>
    <alerts>
        <fullName>Missing_Data_Email_Pitney_B_2014</fullName>
        <description>Missing Data Email-Pitney B 2014</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Order_Email_Templates/Missing_Data_Email_Pitney_B_2014</template>
    </alerts>
    <alerts>
        <fullName>Nemours_Associate_Biometric_creening_survey</fullName>
        <description>Nemours Post Biometric Event Survey</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/Nemours_Associate_Biometric_Screening_survey</template>
    </alerts>
    <alerts>
        <fullName>Nemours_Post_Biometric_Event_Survey</fullName>
        <description>Nemours Post Biometric Event Survey</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/Nemours_Associate_Biometric_Screening_survey</template>
    </alerts>
    <alerts>
        <fullName>Order_has_been_cancelled</fullName>
        <ccEmails>dee.davis@adurolife.com</ccEmails>
        <description>Order has been cancelled</description>
        <protected>false</protected>
        <recipients>
            <recipient>mark.thompson@adurolife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Order_Email_Templates/Cancelled_Orders</template>
    </alerts>
    <alerts>
        <fullName>Phys_Fax_Received_Kindred</fullName>
        <ccEmails>kaycee@worksitewellness.net</ccEmails>
        <description>Phys Fax Received-Kindred</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Order_Email_Templates/Kindred_PFF_Received</template>
    </alerts>
    <alerts>
        <fullName>Physician_Fax_Form_Confirmation_Nelnet_2012</fullName>
        <description>Physician Fax Form Confirmation-Nelnet 2012</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@worksitewellness.net</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Order_Email_Templates/Physician_Fax_Form</template>
    </alerts>
    <alerts>
        <fullName>Physician_Fax_Form_Has_been_recieved</fullName>
        <description>Physician Fax Form Has been recieved</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Physician_Fax_Form_Received</template>
    </alerts>
    <alerts>
        <fullName>Pitney_2014_Completed_Health_Screening</fullName>
        <description>Pitney 2014- Completed Health Screening</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Order_Email_Templates/Pitney_B_2014_Completed_Health_Screening</template>
    </alerts>
    <alerts>
        <fullName>Pitney_2014_Preventative_Screening_Complete</fullName>
        <description>Pitney 2014- Preventative Screening Complete</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Order_Email_Templates/Pitney_B_2014_Preventative_Screening_Completed</template>
    </alerts>
    <alerts>
        <fullName>Post_Event_Survey_Mercy</fullName>
        <description>Post Event Survey- Mercy</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/Post_Screening_Survey_Mercy</template>
    </alerts>
    <alerts>
        <fullName>Post_Event_Survey_Non_Branded</fullName>
        <description>Post Event Survey- Non Branded</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Biometric_Planning_Emails/ADURO_WellmetricsPost_EventSurvey</template>
    </alerts>
    <alerts>
        <fullName>Test_Email_BMI</fullName>
        <description>Test Email- BMI</description>
        <protected>false</protected>
        <recipients>
            <field>PatientEmailH__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@adurolife.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Coaching_Templates/Kohl_s_Weight_Loss</template>
    </alerts>
    <fieldUpdates>
        <fullName>Date_of_Test_Onsite_Only</fullName>
        <field>Date_of_Test__c</field>
        <formula>DATEVALUE( OrderDate__c )</formula>
        <name>Date of Test- Onsite Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Incentive_Sent_Date_update</fullName>
        <field>Incentive_Sent_Date__c</field>
        <formula>NOW()</formula>
        <name>Incentive Sent Date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ldl_update_0</fullName>
        <field>RLdl__c</field>
        <name>Ldl update 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nielsen_Prevent_LA_Transfer</fullName>
        <field>Prevent_Limeade_Transfer__c</field>
        <literalValue>1</literalValue>
        <name>Nielsen - Prevent LA Transfer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RLdl_update</fullName>
        <description>This will cause the RLdl field to auto update if it is blank and Ldl Direct field is populated</description>
        <field>RLdl__c</field>
        <formula>LdL_Direct__c</formula>
        <name>RLdl update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Order_Status_field_to_Error</fullName>
        <description>Sets the Order status field to Error in response to various criteria like an HA Labs import coming in with an Exception.</description>
        <field>Order_Status__c</field>
        <literalValue>Error</literalValue>
        <name>Set Order Status field to Error</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Order_Status_to_Received</fullName>
        <description>Set the field Order Status to Received upon completion of an Onsite Test.</description>
        <field>Order_Status__c</field>
        <literalValue>Received</literalValue>
        <name>Set Order Status to Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tobacco_Status_Preventive_Field_Update</fullName>
        <description>Updates the Pregnancy Tri 2 Field with Today&apos;s date to award the Tobacco Free Incentive Event for LKE Programs</description>
        <field>Pregnancy_Program_Tri_2__c</field>
        <formula>today()</formula>
        <name>Tobacco Status Preventive Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Trig_update_to_0</fullName>
        <field>RTrig__c</field>
        <name>Trig update to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>testing</fullName>
        <field>SFDC_Test__c</field>
        <formula>(Quest_Lab_ID__c)&amp;&quot;|&quot;&amp; TEXT(Fasting_Y_N__c)&amp;&quot;|&quot;&amp; TEXT( Date_of_Test__c)&amp;&quot;|&quot;&amp; TEXT( Tobacco__c )&amp;&quot;|&quot;&amp; TEXT(Results_Tobacco_Free__c )&amp;&quot;|&quot;&amp;M_Results_Cotinine_Pass__c&amp;&quot;|&quot;&amp; TEXT( BP_Systolic_Best__c )&amp;&quot;|&quot;&amp; TEXT( BP_Diastolic_Best__c )&amp;&quot;|&quot;&amp; TEXT( Results_BP__c )&amp;&quot;|&quot;&amp;M_Results_BP_Healthy__c&amp;&quot;|&quot;&amp; TEXT( RCho_Best__c )&amp;&quot;|&quot;&amp; TEXT( Results_TChol__c )&amp;&quot;|&quot;&amp; M_ResultsTC_Healthy__c&amp;&quot;|&quot;&amp; TEXT( RHdl_Best__c )&amp;&quot;|&quot;&amp; TEXT( RTrig_Best__c )&amp; &quot;|&quot;&amp; TEXT( RLdl_Best__c )&amp;&quot;|&quot;&amp; TEXT( RFpg_Best__c )&amp;&quot;|&quot;&amp; TEXT(Fasting_Y_N__c)&amp;&quot;|&quot;&amp; TEXT( Results_Glucose__c )&amp;&quot;|&quot;&amp; M_Results_Glucose_Healthy__c&amp;&quot;|&quot;&amp; TEXT( Waist_to_Height_Ratio_Best__c )&amp; &quot;|&quot;&amp; TEXT( BMI_Best__c )&amp;&quot;|&quot;&amp; Results_BMI_WHTR__c&amp;&quot;|&quot;&amp; M_Results_WstHt_BMI_Healthy__c&amp;&quot;|&quot;&amp; TEXT( M_Results_Pts_Total__c )&amp;&quot;|&quot;&amp; ProgramID__c &amp;&quot;|&quot;&amp; TEXT(HR_Pulse_Best__c)</formula>
        <name>testing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CCHMC-No Passing Email</fullName>
        <actions>
            <name>CCHMC_No_Pass</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Incentive_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>CCHMC 2014-demo</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>contains</operation>
            <value>{</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Onsite Test</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Cancelled Order</fullName>
        <actions>
            <name>Cancelled_orderv2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Notes__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This alerts us when the code changes a status to cancelled.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Concatenate Test Scores v2</fullName>
        <actions>
            <name>testing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Date of Test -Onsite only</fullName>
        <actions>
            <name>Date_of_Test_Onsite_Only</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Onsite Test</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Date_of_Test__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Dee%27s Notification</fullName>
        <actions>
            <name>Dee_s_Order_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Physician Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>contains</operation>
            <value>Pitney,GM Nameplate,PSF,Rosewood,Parker,Chipotle</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Home Access Follow Up</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Incentive Sent Update</fullName>
        <actions>
            <name>Incentive_Sent_Date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Incentive_Sent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kohl%27s 2015-Health Screening</fullName>
        <actions>
            <name>Kohl_s_2015_Healthy_Screening</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Order__c.Incentive_Sent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Kohl&apos;s 2015,Demo Kohl&apos;s 2015</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Participant_Code__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Transfer_Complete__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Physician Form,Lab Test,Onsite Test,External Data,Wellness Center,Venipuncture</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kohl%27s 2015-Missing Data</fullName>
        <actions>
            <name>Kohl_s_Missing_Data_2015</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Order__c.Missing_Data_Kohl_s__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Kohl&apos;s 2015,Demo Kohl&apos;s 2015</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Participant_Code__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Transfer_Complete__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Physician Form,Lab Test,Onsite Test,HTK,External Data,Wellness Center,Venipuncture</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kohl%27s 2015-UnHealthy Screening</fullName>
        <actions>
            <name>Kohl_s_2015_Unhealthy_Screening</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Order__c.Incentive_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Kohl&apos;s 2015,Demo Kohl&apos;s 2015</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Participant_Code__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Physician Form,Lab Test,Onsite Test,HTK,External Data,Wellness Center,Venipuncture</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kohl%27s- Associate Health Screening survey</fullName>
        <actions>
            <name>Kohl_s_Associate_Post_Event_Survey</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Sent Limeade</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Onsite Test</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>equals</operation>
            <value>Kohl&apos;s</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Response__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kohl%27s- Associate Health Screening survey v2</fullName>
        <actions>
            <name>Kohl_s_Post_Event_Survey</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Sent Limeade</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Onsite Test</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>equals</operation>
            <value>Kohl&apos;s</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Response__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Post_Event_Survey_Branded__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kohls Dependents Email - BMI</fullName>
        <actions>
            <name>Kohls_Dependents_BMI_Failed_Wt_Loss</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 5 AND 2 AND 3 AND 4 and 6</booleanFilter>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>contains</operation>
            <value>BMI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Kohl&apos;s Dependents 2014,Test Aduro Results-Current Year</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notEqual</operation>
            <value>{}</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Incentive_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Orders_Compared_Best__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kohls Dependents Email - Nutrition</fullName>
        <actions>
            <name>Kohl_s_Dependents_Nutrition</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 8 AND 9) AND (3 OR 4 OR 5 OR 6) AND 7 and 10</booleanFilter>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notContain</operation>
            <value>BMI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>contains</operation>
            <value>Glucose</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>contains</operation>
            <value>HDL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>contains</operation>
            <value>LDL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>contains</operation>
            <value>Cholesterol</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Kohl&apos;s Dependents 2014,Test Aduro Results-Current Year</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notEqual</operation>
            <value>{}</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Incentive_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Orders_Compared_Best__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kohls Dependents Email - Stress</fullName>
        <actions>
            <name>Kohl_s_Dependents_Address_Stress</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9 AND 10 and 11</booleanFilter>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notEqual</operation>
            <value>{}</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notContain</operation>
            <value>BMI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notContain</operation>
            <value>Glucose</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notContain</operation>
            <value>HDL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notContain</operation>
            <value>LDL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notContain</operation>
            <value>Cholesterol</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>contains</operation>
            <value>Blood Pressure</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Kohl&apos;s Dependents 2014,Test Aduro Results-Current Year</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Incentive_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Orders_Compared_Best__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kohls Email - Nutrition</fullName>
        <actions>
            <name>Kohl_s_Email_Cholesterol_or_Glucose_Fail</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 8 AND 9) AND (3 OR 4 OR 5 OR 6) AND 7 and 10</booleanFilter>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notContain</operation>
            <value>BMI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>contains</operation>
            <value>Glucose</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>contains</operation>
            <value>HDL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>contains</operation>
            <value>LDL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>contains</operation>
            <value>Cholesterol</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Kohl&apos;s 2014,Test Aduro Results-Current Year</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notEqual</operation>
            <value>{}</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Incentive_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Orders_Compared_Best__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Kohls Email - Stress</fullName>
        <actions>
            <name>Kohl_s_Email_Blood_Pressure_Fail</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9 AND 10 and 11</booleanFilter>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notEqual</operation>
            <value>{}</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notContain</operation>
            <value>BMI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notContain</operation>
            <value>Glucose</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notContain</operation>
            <value>HDL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notContain</operation>
            <value>LDL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notContain</operation>
            <value>Cholesterol</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>contains</operation>
            <value>Blood Pressure</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Kohl&apos;s 2014,Test Aduro Results-Current Year</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tests_Not_Met_The_Criteria__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Incentive_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Orders_Compared_Best__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LKE Tobacco-Free - Post Attestation Award</fullName>
        <actions>
            <name>Tobacco_Status_Preventive_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Tobacco Attestation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Tobacco__c</field>
            <operation>equals</operation>
            <value>Y</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_E__c</field>
            <operation>equals</operation>
            <value>LKE</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Ldl Direct auto update to RLdl field</fullName>
        <actions>
            <name>RLdl_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISBLANK( RLdl__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Ldl Update- UMass</fullName>
        <actions>
            <name>Ldl_update_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.RLdl__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>equals</operation>
            <value>UMass Memorial Health Care</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Ldl update to 0</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Order__c.RLdl__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>equals</operation>
            <value>UMass Memorial Health Care</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mercy- Health Screening survey</fullName>
        <actions>
            <name>Post_Event_Survey_Mercy</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Order__c.Screening_End_Time__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Onsite Test</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>contains</operation>
            <value>BeWellWithin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Post_Event_Survey_Branded__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Nemours- Associate Biometric creening survey</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Sent Limeade</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Onsite Test</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>equals</operation>
            <value>Nemours Children&apos;s Hospital</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Response__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Nemours- Employee Biometric Screening survey</fullName>
        <actions>
            <name>Nemours_Post_Biometric_Event_Survey</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Sent Limeade</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Onsite Test</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Nemour&apos;s 2014</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Response__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Nielsen PFF Block for HealthPlan</fullName>
        <actions>
            <name>Nielsen_Prevent_LA_Transfer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Limeade_E__c</field>
            <operation>equals</operation>
            <value>Nielsen</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Physician Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Received</value>
        </criteriaItems>
        <description>Blocks PFF&apos;s from transferring until HealthPlan Status is determined</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Check In 10 Days Prior</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Home_Test_Kit_30_Day_Check_In</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Order__c.CreatedDate</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Home_Test_Kit_Order_Check_In</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Order__c.CreatedDate</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Order Is Duplicate</fullName>
        <actions>
            <name>Home_Test_Kit_Order_Duplicate</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Duplicate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>HTK,Activity Device</value>
        </criteriaItems>
        <description>If &quot;Order Status&quot; equals &quot;Duplicate&quot; and &quot;Order Type&quot; equals &quot;HTK or Activity Device&quot;, then SF sends out email template called &quot;Home Test Kit Order Duplicate Template&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Submitted</fullName>
        <actions>
            <name>Home_Test_Kit_Order_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>HTK</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>notEqual</operation>
            <value>Chipotle Mexican Grill</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.PatientEmailH__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When  Order Status equals Submitted and Order Type equals HTK then an email is sent to email in the field called Patient Email Home</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Submitted-Activity Device</fullName>
        <actions>
            <name>Activity_Device_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>WAP,Device,Device Plus Link,FitBit,Link Only,Activity Device,RAP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>notContain</operation>
            <value>Vulcan,Nelnet,REI,ESI (Electro Scientific Industries )</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Submitted-Activity Device-ESI</fullName>
        <actions>
            <name>Activity_Device_Submitted_ESI</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Activity Device,Device,Device Plus Link,FitBit,Link Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>equals</operation>
            <value>ESI</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Submitted-Activity Device-Nelnet</fullName>
        <actions>
            <name>Activity_Device_Submitted_Email_Nelnet</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Device,Device Plus Link,Activity Device</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>contains</operation>
            <value>Nelnet</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Submitted-Activity Device-REI</fullName>
        <actions>
            <name>Activity_Device_Submitted_Email_REI</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Activity Device,Device,Device Plus Link,FitBit,Link Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>equals</operation>
            <value>REI</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Submitted-Activity Device-Vulcan</fullName>
        <actions>
            <name>Activity_Device_Submitted_Email_Vulcan</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Activity Device,Device,FitBit,Device Plus Link,Link Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>equals</operation>
            <value>Vulcan</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Test Had Errors</fullName>
        <actions>
            <name>Home_Test_Kit_Test_Had_Errors</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Error</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>HTK</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Physician Fax Form Confirmation-Kindred</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Physician Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Kindred 2012</value>
        </criteriaItems>
        <description>This is sent to Nelnet Employees (2012 Program Only) that we received their  phys fax form.  Triggered with Status equals RECEIVED</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Physician Fax Form Confirmation-Nelnet</fullName>
        <actions>
            <name>Physician_Fax_Form_Confirmation_Nelnet_2012</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Physician Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Nelnet 2012</value>
        </criteriaItems>
        <description>This is sent to Nelnet Employees (2012 Program Only) that we received their  phys fax form.  Triggered with Status equals RECEIVED</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Physician Fax Form Received-Kindred</fullName>
        <actions>
            <name>Phys_Fax_Received_Kindred</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Physician Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>equals</operation>
            <value>Kindred  Healthcare</value>
        </criteriaItems>
        <description>This is sent to Kindred Employees  that we received their  phys fax form.  Triggered with Status equals RECEIVED and Account Name is Kindred Healthcare</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Pitney B 2014-Completed Health Screening</fullName>
        <actions>
            <name>Pitney_2014_Completed_Health_Screening</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Order__c.Biometric_Completion_Incentive_Sent__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Pitney B 2014</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Participant_Code__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Transfer_Complete__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Physician Form,Lab Test,Onsite Test</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Missing_Data__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pitney B 2014-Missing Data</fullName>
        <actions>
            <name>Missing_Data_Email_Pitney_B_2014</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Missing_Data__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Pitney B 2014</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Participant_Code__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Transfer_Complete__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Physician Form,Lab Test</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pitney B 2014-Preventative Screening Completed</fullName>
        <actions>
            <name>Pitney_2014_Preventative_Screening_Complete</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Preventive_Screening_Incentivized__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Name</field>
            <operation>equals</operation>
            <value>Pitney B 2014</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Participant_Code__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Preventative Screening</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Post Event Survey- Non Branded</fullName>
        <actions>
            <name>Post_Event_Survey_Non_Branded</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Sent Limeade</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>Onsite Test</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Limeade_Response__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Post_Event_Survey_Non_Branded__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Program_Status__c</field>
            <operation>equals</operation>
            <value>Draft,Active</value>
        </criteriaItems>
        <description>This goes out to all clients except ones that need their own branding. This will send out a click tools survey and map back into Client Satisfaction Events</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set HTK Order Status to Error</fullName>
        <actions>
            <name>Set_Order_Status_field_to_Error</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Exception__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Order_Type__c</field>
            <operation>equals</operation>
            <value>HTK</value>
        </criteriaItems>
        <description>If an HTK order has a value in the Exception field that is not blank, its status should be set to Error.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Onsite Order Status to Received</fullName>
        <actions>
            <name>Set_Order_Status_to_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When an onsite order is updated in the system with any biometric data, set its status to Received in preparation for transfer to Limeade.</description>
        <formula>Onsite_Test_Completed__c  = TRUE &amp;&amp;  ISPICKVAL(Order_Type__c , &quot;Onsite Test&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Trig Update- UMass</fullName>
        <actions>
            <name>Trig_update_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Order__c.RTrig__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order__c.Account__c</field>
            <operation>equals</operation>
            <value>UMass Memorial Health Care</value>
        </criteriaItems>
        <description>Change 0 to blank</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
