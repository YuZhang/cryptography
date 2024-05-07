# 7 CCA安全与认证加密

1. 本节学习用于抵抗CCA攻击的加密方案以及同时保证通信机密性和真实性的认证加密方案。

2. 目录：CCA安全加密，认证加密，确定性加密，密钥派生函数。

3. 回顾CCA不可区分实验

   - CCA不可区分实验 $\mathsf{PrivK}^{\mathsf{cca}}_{\mathcal{A},\Pi}(n)$:
   	1. 挑战者生成密钥 $k \gets \mathsf{Gen}(1^n)$；（为了下一步的预言机）
   	2. $\mathcal{A}$ 被给予输入 $1^n$ 和对加密函数 $\mathsf{Enc}_k(\cdot)$和解密函数$\mathsf{Dec}_k(\cdot)$的**预言机访问（oracle access）** $\mathcal{A}^{\mathsf{Enc}_k(\cdot)}$ 和 $\mathcal{A}^{\mathsf{Dec}_k(\cdot)}$，输出相同长度 $m_0, m_1$ ；
   	3. 挑战者生成随机比特 $b \gets \{0,1\}$，将挑战密文 $c \gets \mathsf{Enc}_k(m_b)$ 发送给 $\mathcal{A}$；
   	4. $\mathcal{A}$ 继续对除了挑战密文$c$之外的预言机的访问，输出$b'$；如果$b' = b$，则$\mathcal{A}$成功$\mathsf{PrivK}^{\mathsf{cca}}_{\mathcal{A},\Pi}=1$，否则 0。
   - 定义：一个加密方案是CCA安全的，如果实验成功的概率与1/2之间的差异是可忽略的。

4. 消息传递方案
   - 我们先不直接处理CCA安全，而是研究一个比CCA更安全的通信场景，其中引入了之前学习的真实性要求；
   - CCA安全与消息的真实性有关，下面学习同时保护消息机密性和真实性的消息传递方案。
   - 密钥生成（**Key-generation**） 算法输出 $k \gets \mathsf{Gen'}(1^n)$. $k = (k_1,k_2)$. $k_1 \gets \mathsf{Gen}_E(1^n)$, $k_2 \gets \mathsf{Gen}_M(1^n)$.
   - 消息传递（**Message transmission** ）算法由 $\mathsf{Enc}_{k_1}(\cdot)$ 和 $\mathsf{Mac}_{k_2}(\cdot)$ 生成，输出 $c \gets \mathsf{EncMac'}_{k_1,k_2}(m)$.
   - 解密（**Decryption**）算法由 $\mathsf{Dec}_{k_1}(\cdot)$ 和 $\mathsf{Vrfy}_{k_2}(\cdot)$ 生成，输出 $m \gets \mathsf{Dec}'_{k_1,k_2}(c)$ 或 $\bot$.
   - 正确性需求: $\mathsf{Dec}'_{k_1,k_2}(\mathsf{EncMac}'_{k_1,k_2}(m)) = m$.
   - 注：在消息传递方案中，消息被加密并且被MAC。在解密算法中，当密文没有通过真实性验证时，输出空（可以理解为“报错”）；这意味着未认证的密文无法解密。

5. 定义安全消息传递
   - 先定义保护真实性的认证通信，然后定义同时保护机密性和真实性的认证加密。
   - 安全消息传递实验（**secure message transmission**） $\mathsf{Auth}_{\mathcal{A},\Pi'}(n)$:
     - $k = (k_1,k_2) \gets \mathsf{Gen}'(1^n)$.
     - $\mathcal{A}$ 输入 $1^n$ 和对 $\mathsf{EncMac'}_k$的预言机访问，并输出 $c \gets \mathsf{EncMac'}_{k}(m)$.
     - $m := \mathsf{Dec}'_k(c)$. $\mathsf{Auth}_{\mathcal{A},\Pi'}(n) = 1 \iff m \ne \bot \land\; m \notin \mathcal{Q}$.
   - 定义：$\Pi'$ 实现认证通信（ **authenticated communication**），如果 $\forall$ ppt $\mathcal{A}$, $\exists\; \mathsf{negl}$ 使得，$\Pr[\mathsf{Auth}_{\mathcal{A},\Pi'}(n) = 1] \le \mathsf{negl}(n).$
   - 定义：$\Pi'$ 是安全的认证加密（**secure Authenticated Encryption (A.E.)**）， 如果其既是CCA安全的也是实现了认证通信。
   - 问题：CCA安全意味着A.E.吗？（作业）

6. 关于认证加密的例题
   - 如果认为是安全的，那么利用反证法证明；
   - 如果认为是不安全的，那么或者可以伪造消息，或者破解明文；

7. 加密和认证组合
   - 加密和认证如何组合来同时保护机密性和真实性？
   - 加密并认证（**Encrypt-and-authenticate**） (例如, SSH)：$c \gets \mathsf{Enc}_{k_1}(m),\; t \gets \mathsf{Mac}_{k_2}(m).$
   - 先认证后加密（**Authenticate-then-encrypt**） (例如, SSL)：$t \gets \mathsf{Mac}_{k_2}(m),\; c \gets \mathsf{Enc}_{k_1}(m\| t).$
   - 先加密后认证（**Encrypt-then-authenticate**） (例如, IPsec)：$c \gets \mathsf{Enc}_{k_1}(m),\; t \gets \mathsf{Mac}_{k_2}(c).$

8. 分析组合的安全性
   - 采用全或无（All-or-nothing）分析，即一种组合方案要么在全部情况下都是安全的，要么只要存在一个不安全的反例就被认为是不安全的；
   - 加密并认证: $\mathsf{Mac}'_k(m) = (m, \mathsf{Mac}_k(m))$. 
     - 这表明，认证可能泄漏消息。
   - 先认证后加密: 
     - 一个例子：
       - $\mathsf{Trans}: 0 \to 00; 1 \to 10/01$; 
       - $\mathsf{Enc}'$ 采用CTR模式; $c = \mathsf{Enc}'(\mathsf{Trans}(m\| \mathsf{Mac}(m)))$.
       - 将 $c$ 的前两个比特翻转并且验证密文是否有效。$10/01 \to 01/10 \to 1$, $00 \to 11 \to \bot$.
         - 明文为1时，不改变明文；明文为0时，解密无效
       - 如果可以有效解密，则意味着消息的第一比特是1，否则是0； 
       - 对于任何MAC，这都不是CCA安全的；
     - 这个例子表明，缺乏完整性保护时，敌手可解密，而密文是否有效也价值1个比特的信息。
   - 先加密后认证: 解密: 如果 $\mathsf{Vrfy}(\cdot) = 1$， 那么 $\mathsf{Dec}(\cdot)$； 否则，输出 $\bot$。下面来证明。

9. 构造AE/CCA安全的加密方案

   - 思想：令解密预言机没用。AE/CCA =CPA-then-MAC。
   - $\Pi_E = (\mathsf{Gen}_E, \mathsf{Enc}, \mathsf{Dec})$, $\Pi_M = (\mathsf{Gen}_M, \mathsf{Mac}, \mathsf{Vrfy})$. $\Pi'$:
     - $\mathsf{Gen}'(1^n)$: $k_1 \gets \mathsf{Gen}_E(1^n)$ and $k_2 \gets \mathsf{Gen}_M(1^n)$
     - $\mathsf{Enc}'_{k_1,k_2}(m)$: $c \gets \mathsf{Enc}_{k_1}(m)$, $t \gets \mathsf{Mac}_{k_2}(c)$ and output $\left< c,t \right>$
     - $\mathsf{Dec}'_{k_1,k_2}(\left< c,t \right>) = \mathsf{Dec}_{k_1}(c)\ \text{if}\ \mathsf{Vrfy}_{k_2}(c,t) \overset{?}{=} 1;\ \text{otherwise}\ \bot$
   - 加密时，先加密后对密文做认证；解密时，先验证，若未通过验证，则输出空，否则解密。

10. AE/CCA安全加密方案证明

    - 定理：如果 $\Pi_E$ 是CPA安全的私钥加密方案并且 $\Pi_M$ 是一个安全的MAC，那么构造 $\Pi'$ 是CCA安全的。

    - 证明：$\mathsf{VQ}$ （有效查询）: $\mathcal{A}$ 向预言机$\mathsf{Dec}'$提交一个新查询并且 $\mathsf{Vrfy}=1$。*注：VQ表示敌手向预言机查询可经过验证并解密。*

    - $\Pr[\mathsf{PrivK}^{\mathsf{cca}}_{\mathcal{A},\Pi'}(n)=1] \le \Pr[\mathsf{VQ}] + \Pr[\mathsf{PrivK}^{\mathsf{cca}}_{\mathcal{A},\Pi'}(n)=1 \land \overline{\mathsf{VQ}}]$

    - 我们需要证明以下：

      - $\Pr[\mathsf{VQ}]$ 是可忽略的；敌手无法利用解密预言机获得有效查询；

      - $\Pr[\mathsf{PrivK}^{\mathsf{cca}}_{\mathcal{A},\Pi'}(n)=1 \land \overline{\mathsf{VQ}}] \le \frac{1}{2} + \mathsf{negl}(n)$；在无法利用解密预言机时难以破解加密方案。

11. 证明敌手无法利用解密预言机获得有效查询

    - 思路：将 $\mathcal{A}_M$ (有预言机 $\mathsf{Mac}_{k_2}(\cdot)$攻击 $\Pi_M$ ) 规约到 $\mathcal{A}$。
    -  $\mathcal{A}_M$以 $\mathcal{A}$ 为子函数来运行。$\mathcal{A}$ 将产生$q(n)$个解密预言机查询，$\mathcal{A}_M$ 预先从中均匀随机选择一个编号 $i \gets \{1,\dotsc,q(n)\}$，并将该查询作为输出的伪造；
    - 当$\mathcal{A}$以$m$查询加密预言机时， $\mathcal{A}_M$ 产生加密密钥并以加密预言机的角色先计算密文$c$，然后用密文查询MAC预言机并将$\left<c, t\right>$返回给$\mathcal{A}$；
    - 当$\mathcal{A}$以$\left<c, t\right>$查询解密预言机时，如果这是第 $i$ 个查询，那么$\mathcal{A}_M$ 输出$\left<c, t\right>$并停止；否则，如果这是曾经在加密预言机查询过的，$\mathcal{A}_M$ 返回明文，否则，返回$\bot$（因为只要$\mathsf{VQ}$未发生，就应该返回$\bot$）;
    - $\mathsf{Macforge}_{\mathcal{A}_M,\Pi_M }(n)=1$ 的条件是，只有当 $\mathsf{VQ}$ 发生并且 $\mathcal{A}_M$ 正确地猜测了 $i$ （概率为 $1/q(n)$）。
    - $\Pr [\mathsf{Macforge}_{\mathcal{A}_M,\Pi_M }(n)=1] \ge \Pr[\mathsf{VQ}]/q(n).$

12. 证明在无法利用解密预言机时难以破解加密方案

    - 思路：将 $\mathcal{A}_E$ (以 $\mathsf{Enc}_{k_1}(\cdot)$ 预言机来攻击 $\Pi_E$ ) 规约到 $\mathcal{A}$。

    -  $\mathcal{A}_E$ 以 $\mathcal{A}$ 为子函数来运行。 $\mathcal{A}_E$ 扮演 $\mathcal{A}$ 的加密预言机和解密预言机方法与 $\mathcal{A}_M$ 的类似；

    - 实验 $\mathsf{PrivK}^{\mathsf{cpa}}_{\mathcal{A}_E,\Pi_E}$ 与实验 $\mathsf{PrivK}^{\mathsf{cca}}_{\mathcal{A},\Pi'}$ 的运行一样， $\mathcal{A}_E$ 输出与 $\mathcal{A}$ 一样的 $b'$ ；

    - $\Pr[\mathsf{PrivK}^{\mathsf{cpa}}_{\mathcal{A}_E,\Pi_E}(n)=1 \land \overline{\mathsf{VQ}}] = \Pr[\mathsf{PrivK}^{\mathsf{cca}}_{\mathcal{A},\Pi'}(n)=1 \land \overline{\mathsf{VQ}}]$；

       $\Pr [\mathsf{PrivK}^{\mathsf{cpa}}_{\mathcal{A}_E,\Pi_E }(n)=1] \ge \Pr[\mathsf{PrivK}^{\mathsf{cca}}_{\mathcal{A},\Pi'}(n)=1 \land \overline{\mathsf{VQ}}]$。

13. 认证加密理论与实践

    - 定理：$\Pi_E$ 是CPA安全的并且 $\Pi_M$ 是一个带有唯一标签的安全MAC（强安全MAC），那么由先加密后认证得到的 $\Pi'$ 是安全的。*注：强安全MAC是指一个消息只有一个有效标签*
    - GCM (Galois/Counter Mode): 先CTR加密，然后做 Galois MAC. (RFC4106/4543/5647/5288 on IPsec/SSH/TLS)
    - EAX: 先CTR 加密，然后 CMAC（Cipher-based MAC）。
    - 定理：先认证后加密方法是安全的，如果 $\Pi_E$ 是CTR模式或者CBC模式。
    - CCM (Counter with CBC-MAC): 先 CBC-MAC 后 CTR 加密。 (802.11i, RFC3610)
    - OCB (Offset Codebook Mode): 将MAC整合到加密中。 (是CCM, EAX的2倍快)
    - 上述方案都支持 AEAD (A.E. with associated data): 部分是明文并且整个消息被认证。这在实践中是很常用的，例如一个IP报文需要加密，但IP头部需要以明文方式传输。

14. 安全消息传递补充

    - 认证可能泄漏消息；*注：完整性不同于机密性*
    - 安全消息传递意味着CCA安全性，但反之未必；
    - 不同安全目标应该采用不同的密钥；否则，可能泄漏消息，例如 $\mathsf{Mac}_k(c)=\mathsf{Dec}_k(c)$。
    - 实现可能摧毁理论上的安全性：
       - Padding Oracle 攻击（TLS 1.0）: 解密返回两种类型错误: padding error，MAC error；敌手通过猜测来获得最后一字节，如果没有padding错误；参考之前在CCA部分学习的Padding Oracle攻击；
       - 攻击非原子解密（SSH Binary Packet Protocol）：解密时，分三步 (1)解密消息长度； (2)读取长度所表明的包数； (3) 检查MAC；敌手针对这种非原子解密过程，实施攻击分三步 (1)发送密文 $c$；(2)发送 $l$ 个包直到“MAC error”发生；(3)获得密文对应的明文 $l = \mathsf{Dec}(c)$。

15. 确定性CPA安全（**Deterministic CPA Security**）

    - 应用：在加密数据库索引后，检索时需要加密明文来检索密文；在磁盘加密中，密文大小需要与明文一样大。但之前学习的CPA安全加密都是非确定性的，而且密文比明文长。
    - 确定性加密（Deterministic encryption）：相同的消息在相同密钥下被加密为相同的密文。
      - 问题：这样能实现CPA安全吗？答案是不可能，因为CPA安全意味着非确定性加密，密文长于明文。于是，我们需要新的安全定义。
    - 确定性CPA安全（Deterministic CPA Security）: 如果从来不用相同的密钥加密同一个消息两次，实现CPA安全，即密钥和消息对$\left<k,m\right>$ 是唯一的。
      - 这里引入新的条件：消息是可重复的，密钥也可重复，但同一密钥不能重复加密同一消息。这是为了实现CPA而做出的必要改变。相当于获得确定性下CPA安全的同时，丧失同一个消息被同一个密文加密多次的能力。
    - 一个PRP就是固定长度的确定性CPA安全加密方案。
    - 确定性认证加密（Deterministic Authenticated Encryption，DAE）：与上面的确定性CPA安全概念类似。

16. 在变长加密中的一个常见错误

    - 常见错误：在 CBC/CTR 模式中采用固定的$IV$。这虽然是确定性的，但是不安全。
    - 敌手能够查询 $(m_{q1}, m_{q2})$ 并且得到 $(c_{q1}, c_{q2})$；然后输出明文：$IV\oplus c_{q1} \oplus m_{q2}$ 并且期待密文： $c_{q2}$。注：第一个PRF的输入就是$IV\oplus IV\oplus c_{q1} \oplus m_{q2} = c_{q1} \oplus m_{q2}$ 
    - 下面介绍三种变长明文的CPA安全的确定性加密方案。

17. 合成初始向量法（**Synthetic** IV **(SIV)**）

    - 思路：保持初始向量对敌手仍是不可预测的，但是由明文和密钥确定的。
    - 合成初始向量 SIV ：对同一对$\left<k,m\right>$使用一个固定的 $IV$ ，用明文通过PRF生成SIV，再用另一个密钥加密；
    - 一个PRF $F$，和一个 CPA安全 $\Pi:(\mathsf{Enc}_k(r,m), \mathsf{Dec}_k(r,s))$；
    - 生成两个密钥 $(k_1,k_2) \gets \mathsf{Gen}$; 得到合成初始向量 $SIV \gets F_{k_1}(m)$；以SIV做为IV来加密 $c = \left<SIV,\mathsf{Enc}_{k_2}(SIV,m) \right>$；
    - 采用SIV-CTR可以实现 DAE：MAC标签 $t := SIV$ ，然后应用 $CTR_{k_2}$。

18. 宽块PRP（**Wide Block PRP**）

    - 思路：因为一个PRP本身是确定性CPA安全，因此，构造一个大的PRP来加密。
    - 宽块PRP就是PRP，从较短的PRP（例如AES）构造一个更长的块大小，和消息一样大（例如磁盘上一个扇区）。
    - PRP-based DAE： $\mathsf{Enc}_k(m\| 0^{\ell})$。在解密中$\mathsf{Dec}$，如果后半部分明文 $\neq 0^{\ell}$，输出 $\perp$。
    - 窄块（Narrow block）可能泄漏信息，由于有一些块相同时，可能泄漏信息。
    - 标准: IEEE P1619.2 中 CBC-mask-CBC (CMC) 和 ECB-mask-ECB (EME)  。
    - 代价：由于两轮加密比SIV方法慢两倍。

19. 可调加密（**Tweakable Encryption**）

    - 思路：从密钥生成不同的密钥，一次一密
    - 无扩展加密（Encryption without expansion）: 明文空间与密文空间相同 $\mathcal{M} = \mathcal{C}$ 意味着没有完整性保护的确定性加密，例如磁盘加密。
    - Tweak是一个类似初始向量的值，在同一密钥下，不同的tweak构造不同的PRP。每一个块采用不同的tweak。
    - 可调块密码（Tweakable block ciphers）：用一个密钥生成许多PRP $\mathcal{K} \times \mathcal{T} \times \mathcal{X} \to \mathcal{X}$, $\mathcal{T}$ 是tweak集合。
    - 一种简单的解决方法：以一个Tweak $t$来生成密钥 $k_t = F_k(t), t=1,\dots,\ell$，但要加密两次效率不高，需要更有效的方法。

20. XTS

    - XTS：XEX(Xor-Encrypt-Xor)-based tweaked-codebook mode with ciphertext stealing。 (XTS-AES, NIST SP 800-38E)
    - XEX: $c = F_k(m\oplus x)\oplus x$，其中在 Galois 域上 $x=F_k(I)\otimes 2^j$ ，在扇区 $I$中块 $j$ 对应的tweak是 $(I,j)$ 。
    - Ciphertext stealing (CTS)：无需填充（padding），没有扩展。

21. 密钥派生函数（**Key Derivation Function (KDF)**）

    - 密钥派生函数（Key Derivation Function，KDF）：从一个秘密的原密钥 $sk$ 产生许多密钥；
    - 对于均匀随机的 $sk$：$F$ 是 PRF, $ctx$ 是标识应用的唯一串，$\mathsf{KDF}(sk,ctx,l) = \left<F_{sk}(ctx\|0),F_{sk}(ctx\|1)\cdots,F_{sk}(ctx\|l)\right>.$
    - 对于非均匀随机的 $sk$：提取并扩展范式 
       - 提取（extract）： HKDF $k \gets \mathsf{HMAC}(salt,sk)$， $salt$（盐）是一个随机数。用盐来向密钥添加熵。
       - 扩展（expand）：与上面均匀随机情况一样。

22. 基于口令的KDF（**Password-Based KDF, PBKDF**）

    - 密钥延展（Key stretching）增加测试密钥的时间 (使用较慢的哈希函数)。
    - 密钥加强（Key strengthening）增加密钥的长度和随机性 (使用盐)。
    - PKCS\#5 (PBKDF1)：$H^{(c)}(pwd\|salt)$， 哈希函数迭代 $c$ 次。
    - 敌手攻击，或者尝试被加强的密钥 (更大的密钥空间)，或者尝试初始密钥 (每个密钥花费更长时间)。

23. IV，Nonce，Counter，Tweak和Salt

    - IV：密码学原语的输入，提供随机性。
    - nonce：用来标记一次通信的只使用一次的一个数。
    - counter：一个连续的数，用作nonce或IV。
    - tweak：在一个密码中对每个块只用一次的输入。
    - salt：随机比特，用于创建一个函数的输入。

24. 总结

    - 略

