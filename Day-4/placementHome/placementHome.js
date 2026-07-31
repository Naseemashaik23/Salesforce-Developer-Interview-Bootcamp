<template>
    <lightning-card title="Placement Portal">
        <div class="slds-p-around_medium">

            <h1 style="font-size:22px;font-weight:bold;">
                Welcome to Vishnu Placement Portal
            </h1>

            <br/>

            <p><strong>Today's Date:</strong> {todayDate}</p>
            <p><strong>Welcome Student:</strong> {studentName}</p>

            <hr/>

            <p><strong>Student Name:</strong> {studentName}</p>
            <p><strong>Roll Number:</strong> {rollNumber}</p>
            <p><strong>Department:</strong> {department}</p>

            <hr/>

            <p><strong>Number of Companies:</strong> {companies}</p>
            <p><strong>Number of Jobs:</strong> {jobs}</p>
            <p><strong>Applications Submitted:</strong> {applications}</p>

            <hr/>

            <lightning-button
                label="Show Welcome Message"
                variant="brand"
                onclick={showMessage}>
            </lightning-button>

            <br/><br/>

            <p>{welcomeMessage}</p>

            <hr/>

            <p><strong>Status:</strong> {status}</p>

            <lightning-button
                label="Apply Now"
                variant="success"
                onclick={changeStatus}>
            </lightning-button>

        </div>
    </lightning-card>
</template>
