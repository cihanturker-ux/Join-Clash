using System.Collections;
using UnityEngine;
using thirtwo.Scripts.PlayerController;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
public class Player : MonoBehaviour
{
    PlayerMovement playerMovement;
    private Transform targetBoss;
    public Transform targetenemy;
    private NavMeshAgent navMeshAgent;
    private bool reached;
    private bool once = false;
    public int childNumber;
    private float cosinus;
    private float sinus;
    private Transform endPoint;
    private void Start()
    {
        playerMovement = FindObjectOfType<PlayerMovement>();
        navMeshAgent = GetComponent<NavMeshAgent>();
        endPoint = playerMovement.endPoint;
        if (targetBoss != null)
        {
            targetBoss = playerMovement.targetBoss;
        }
        navMeshAgent.stoppingDistance = 2f;
        //navMeshAgent.autoBraking = false;

    }


    private void Update()
    {
        reached = playerMovement.reached;
        if (reached)
        {
            if (!once)
            {
                once = !once;
                Matematichal();
            }
            transform.parent = null;
            //  navMeshAgent.destination = targetEnemy.position + new Vector3(sinus,0,cosinus);
            if (targetBoss != null)
            {
                transform.position = Vector3.Lerp(transform.position, targetBoss.position + new Vector3(sinus, 0, cosinus), 0.5f * Time.deltaTime);
                transform.LookAt(new Vector3(targetBoss.position.x, transform.position.y + 0.5f, targetBoss.position.z));
                //vurma animasyonu
            }
            else if (targetenemy != null)
            {
                transform.position = Vector3.Lerp(transform.position, targetenemy.position, 0.5f * Time.deltaTime);

                //vurma animasyonu
            }
            else
            {
                transform.position = Vector3.Lerp(transform.position, endPoint.position, 0.5f * Time.deltaTime);
                //bitiş noktasına git.
            }
            if (Vector3.Distance(transform.position, endPoint.position) < 0.5f)
            {
                GameManager.gameEnded = true;
            }
            //hit animation
        }
       
    }

   public void TakeDamage()
    {
        StartCoroutine(TakeDamageCo());
    }

    private void Matematichal()
    {
        cosinus = Mathf.Cos(childNumber * 15);
        sinus = Mathf.Sin(childNumber * 15);
    }

    private IEnumerator TakeDamageCo()
    {
        yield return new WaitForSeconds(0.5f);
        Destroy(gameObject);
    }
}
