#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "procinfo.h"
#include "syscall.h"


extern struct proc proc[];

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_getmemusage(void)
{
    int pid;
    struct proc *p = 0;

    argint(0, &pid);  // get the pid argument from user space

    for (struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
        if (pp->pid == pid) {
            p = pp;
            break;
        }
    }

    if (p) {
        return (uint64)p->sz;
    } else {
        return -1;
    }
}

uint64
sys_ps(void)
{
    struct procinfo *u_procinfo;
    int max;

    // args from user space
    argaddr(0, (uint64 *)&u_procinfo);
    argint(1, &max);

    int count = 0;

    for (struct proc *p = proc; p < &proc[NPROC] && count < max; p++) {
        if (p->state != UNUSED) {
            struct procinfo pi;
            pi.pid = p->pid;
            pi.state = p->state;
            pi.sz = p->sz;
            safestrcpy(pi.name, p->name, sizeof(pi.name));

            if (copyout(myproc()->pagetable, (uint64)(u_procinfo + count), (char *)&pi, sizeof(pi)) < 0)
                return -1;

            count++;
        }
    }

    return count; // number of procs copied
}

uint64
sys_pinfo(void)
{
  int pid;
  uint64 uaddr;
  struct procinfo pi;
  struct proc *p;
  struct proc *curproc = myproc();

  argint(0, &pid);
  argaddr(1, &uaddr);
  printf("sys_pinfo: asked for pid %d\n", pid);


  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->pid == pid) {
      pi.pid = p->pid;
      pi.ppid = p->parent ? p->parent->pid : -1;
      pi.state = p->state;
      pi.sz = p->sz;
      safestrcpy(pi.name, p->name, sizeof(pi.name));
      release(&p->lock);
      printf("sys_pinfo: filling pi -> pid %d, ppid %d, name %s\n", pi.pid, pi.ppid, pi.name);

      if (copyout(curproc->pagetable, uaddr, (char*)&pi, sizeof(pi)) < 0)
        return -1;
      return 0;
    }
    release(&p->lock);
  }

  return -1;
}


uint64
sys_getidlepid(void)
{
    struct proc *p;
    int idle_pid = -1;

    for(p = proc; p < &proc[NPROC]; p++) {
        acquire(&p->lock);
        if(p->state == SLEEPING) {
            idle_pid = p->pid;
            release(&p->lock);
            break;
        }
        release(&p->lock);
    }
    return idle_pid;
}

int sys_getactiveprocesses(void) {
  uint64 pids_addr;  // user pointer (uint64 for user space address)
  int max_count;

argint(0, &max_count);
argaddr(1, &pids_addr);


  int count = 0;
  int temp_pids[NPROC];  // kernel buffer to store PIDs

  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++) {
      if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING) {
          if (count < max_count) {
              temp_pids[count++] = p->pid;
          }
      }
  }

  // Copy kernel buffer to user space
  if (copyout(myproc()->pagetable, pids_addr, (char *)temp_pids, count * sizeof(int)) < 0)
      return -1;

  return count;
}