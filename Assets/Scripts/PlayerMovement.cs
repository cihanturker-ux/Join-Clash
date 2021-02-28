using UnityEngine;

namespace thirtwo.Scripts.PlayerController
{
    [RequireComponent(typeof(Rigidbody))]
    public class PlayerMovement : MonoBehaviour
    {
        [Header("Components")]
        private Rigidbody rb;
        private GameManager gameManager;
        public Transform reachPoint;
        public Transform targetBoss;
        public Transform[] targetEnemies;
        public Transform endPoint;
        
        //public Transform  
        [Header("Character Movement Stats")]
        [SerializeField] private float forwardSpeed = 5f;
        [SerializeField] private float horizontalSpeed = 5f;
        [SerializeField] private float deadZone = 0.1f;
        Vector3 movementDelta;
        private float mouseStart;

        [Header("Variables")]
        public float offsetZ;
        public float offsetX;
        /*[HideInInspector]*/
        public bool reached = false;
        private bool once = false;

        [SerializeField] private float distance;
        private Vector3 colliderPoint;
        private Vector3 colliderPosition;
        private float colliderDeltaX;
        private float colliderDeltaZ;
        private float tempZ;
        //group enemy
        private int tempChildCount;
        private int i;
        private GameObject tempParent;

        private void Start()
        {
            rb = GetComponent<Rigidbody>();
            gameManager = FindObjectOfType<GameManager>();
        }

        private void Update()
        {
            distance = reachPoint.position.z - transform.position.z;
            if (distance <= 0.2f)
            {
                reached = true;
                if (!once)
                {
                    once = !once;

                    for (int k = 0; k < transform.childCount; k++)
                    {
                        transform.GetChild(k).GetComponent<Player>().childNumber = k;
                        if (targetBoss == null)
                        {
                            transform.GetChild(k).GetComponent<Player>().targetenemy = targetEnemies[k%targetEnemies.Length];
                        }

                    }
                }
            }
            if (!gameManager.gameStarted || reached) return;

            GetInput();

        }
        private void FixedUpdate()
        {
            if (!gameManager.gameStarted || reached) return;

            Move();
        }


        private void GetInput()
        {
            movementDelta = Vector3.forward * forwardSpeed;
            if (Input.GetMouseButtonDown(0))
            {
                mouseStart = Input.mousePosition.x;
            }
            else if (Input.GetMouseButton(0))
            {
                float delta = Input.mousePosition.x - mouseStart;
                mouseStart = Input.mousePosition.x;
                if (Mathf.Abs(delta) <= deadZone)
                {
                    delta = 0;
                }
                else
                {
                    delta = Mathf.Sign(delta);
                }
                if (transform.position.x > 4.5f && delta > 0)
                {
                    return;
                }
                else if (transform.position.x < -4.5f && delta < 0)
                {
                    return;
                }
                movementDelta += Vector3.right * horizontalSpeed * delta;
            }
        }

        private void Move()
        {
            rb.MovePosition(rb.position + movementDelta * Time.fixedDeltaTime);
        }

        private void EnemyCatcher(Collider other)
        {
            colliderPosition = other.transform.position;
            Debug.Log(colliderPosition);
            colliderPoint = other.ClosestPoint(transform.position);
            Debug.Log(colliderPoint);
            colliderDeltaX = colliderPosition.x - colliderPoint.x;
            Debug.Log("x" + colliderDeltaX);
            colliderDeltaZ = colliderPosition.z - colliderPoint.z;
            Debug.Log("z" + colliderDeltaZ);
            tempZ = offsetZ + colliderDeltaZ;
            Debug.Log("tempz" + tempZ);
            other.transform.rotation = transform.rotation;
            other.transform.parent = transform;
            other.transform.localPosition = new Vector3(colliderDeltaX, 0, tempZ);
            other.isTrigger = false;
            other.gameObject.GetComponent<MeshRenderer>().material = gameObject.GetComponent<MeshRenderer>().material;
            other.tag = "Player";
            // other.gameObject.AddComponent<Player>();
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.tag == "cube")
            {
                EnemyHunt(other);
            }
            else if (other.tag == "cubeGroup")
            {
                EnemyGroupHunt(other);
            }

        }



        void EnemyHunt(Collider other)
        {
            other.transform.rotation = transform.rotation;
            other.transform.parent = transform;
            other.isTrigger = false;
            other.gameObject.GetComponent<MeshRenderer>().material = gameObject.GetComponent<MeshRenderer>().material;
            other.tag = "Player";
            other.gameObject.AddComponent<Player>();
        }

        void EnemyGroupHunt(Collider other)
        {
            tempChildCount = other.transform.parent.childCount;
            Debug.Log(tempChildCount);
            tempParent = other.transform.parent.gameObject;
            for (i = 0; i < tempChildCount; i++)
            {

                tempParent.transform.GetChild(0).rotation = transform.rotation;
                tempParent.transform.GetChild(0).GetComponent<Collider>().isTrigger = false;
                tempParent.transform.GetChild(0).GetComponent<MeshRenderer>().material = gameObject.GetComponent<MeshRenderer>().material;
                tempParent.transform.GetChild(0).tag = "Player";
                tempParent.transform.GetChild(0).gameObject.AddComponent<Player>();
                tempParent.transform.GetChild(0).parent = transform;

            }
        }


    }
}
