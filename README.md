# ODATA
**Example 1: To fetch Product details using Code method**
**Steps to create ODATA service:**
Step1: Create a project in SEGW- Gateway Service Builder.
![Uploading image.png…]()

Step2: Define Entity Type and Entity Set.
Tick the checkbox “Create Related Entity set” to create the Entity Set with respect to entity.
Add the Properties in the Entity Type.
Add the Properties ProductId as key , Name , Description. It will prompt to save the details in the TR now.
Step3: Generate Project to create Runtime Artifacts.
It will again prompt to save it in a TR.
DPC, MPC, DPC_EXT, MPC_EXT classes got generated.
Since the requirement is to fetch / read Product details, we can use GetEntitySet(Query) method.
•	GetEntity(Read): To read a single record.
•	GetEntitySet(Query) :  To read multiple records.
Here, logic can be implemented via Coding by selecting Go to ABAP Workbench or through Map To Data source.
After selecting Go to ABAP Workbench, it is navigating to the DPC extension class.
Redefine the method PRODUCTSET_GET_ENTITYSET:
While redefining the method, it is recommended to inherit the existing functionality of the get_entityset method.
Redefined method will be visible in black color.
**Step4: Service Registration:**
Service Registration is a one-time activity.
Maintain the service in /IWFND/MAINT_SERVICE
Display info in XML format:
Display Entityset details:
JSON format: Javascript Object Notation
Debugging an ODATA service: 
Place an external break-point in the method “PRODUCTSET_GET_ENTITYSET”
Go to transaction /IWFND/MAINT_SERVICE and select Entityset “ProductSet ” then click on execute.
Control goes to debugger
Each Project in SEGW represents a ODATA service.
Custom business logic should be written in the DPC extension class, otherwise implemented code will be removed during the project reactivation.
Model Provider class contains definition part. Whereas Data Provider class contains implementation i.e, runtime logic.
<ENTITYSET>_ GET_ENTITYSET.
<ENTITYSET>_ GET_ENTITY.
<ENTITYSET>_ CREATE_ENTITY
<ENTITYSET>_ UPDATE_ENTITY
<ENTITYSET>_ DELETE_ENTITYSET.	
Example: PRODUCTSET_GET_ENTITY.
                 PRODUCTSET_GET_ENTITYSET.
                 PRODUCTSET_CREATE_ENTITY.
                 PRODUCTSET_UPDATE_ENTITY.
                PRODUCTSET_DELETE_ENTITY.
ZCL_ZEPM_PRODUCT_DPC_EXT is a child class which is inherited from its super class ZCL_ZEPM_PRODUCT_DPC.


