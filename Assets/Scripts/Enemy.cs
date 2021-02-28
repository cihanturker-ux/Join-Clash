using System.Collections;
using UnityEngine;
public enum Status
{
    boss,
    normal
};
public class Enemy : MonoBehaviour
{
    [SerializeField] private float hitInterval;
    [SerializeField]
    [Tooltip("Only for boss pref 50")]
    private float health = 50;
    public Status status;

 

    private IEnumerator TakeDamageCO()
    {
        if (status == Status.normal)
        {
            yield return new WaitForSeconds(0.5f);
            Destroy(gameObject);
        }
        else
        {
            health -= 10;
            if (health <= 0)
            {
                Destroy(gameObject);
            }
            yield return new WaitForSeconds(0.5f);
            
        }
    }
    private void OnTriggerEnter(Collider collision)
    {
        
        if (collision.tag == "Player")
        {
            Debug.Log("tapping");
            StartCoroutine(GiveDamage(collision));
            StartCoroutine(TakeDamageCO());
        }
    }

    private IEnumerator GiveDamage(Collider collision)
    {
        yield return new WaitForSeconds(hitInterval);
        collision.GetComponent<Player>().TakeDamage();
    }
}
