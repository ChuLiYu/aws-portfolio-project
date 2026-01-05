# EC2 实例分析报告

## 执行时间
2026-01-04

## 调查对象
- Instance 1: `i-02f2caee522bb3725` (ec2-dev-api-us-east-1a)
- Instance 2: `i-0262707311b4bddbd` (Web Server from Module)

---

## 🔍 详细分析

### 基本信息对比

| 属性 | i-02f2caee522bb3725 | i-0262707311b4bddbd |
|-----|---------------------|---------------------|
| **名称** | ec2-dev-api-us-east-1a | Web Server from Module |
| **启动时间** | 2025-12-21 23:24:46 UTC | 2025-12-21 23:24:46 UTC |
| **运行时长** | ~14天 | ~14天 |
| **实例类型** | t3.micro | t3.micro |
| **AMI** | ami-0030e4319cbf4dbf2 | ami-0030e4319cbf4dbf2 |
| **状态** | Running | Running |
| **VPC** | vpc-023bc94610af8aa73 | vpc-023bc94610af8aa73 |
| **子网** | subnet-0d142a262f23b0ebd | subnet-0d142a262f23b0ebd |
| **公网 IP** | 3.83.248.118 | 34.229.179.239 |

**相同点**:
- ✅ 同一天同一时间启动（可能是一起创建的）
- ✅ 使用相同的 AMI
- ✅ 在同一个 VPC 和子网
- ✅ 都是 t3.micro 实例类型

### 运行的服务

两台 EC2 都运行 **"Live Visitor Feed"** 网页：
```html
<title>Live Visitor Feed</title>
<h1>Visits</h1>
```

**判断**: 这是一个访问者统计/监控页面，可能是学习项目或演示用途。

### 安全组配置

**Instance 1 (i-02f2caee522bb3725)**:
- Security Group: `web_server_sg`
- 开放端口: 80 (HTTP) - 允许全网访问 (0.0.0.0/0)

**Instance 2 (i-0262707311b4bddbd)**:
- Security Groups: `vpc-web`, `ingress-ssh`, `vpc-ping`
- 开放端口: 80 (HTTP) - 允许全网访问 (0.0.0.0/0)
- 可能还开放: SSH (22), ICMP (ping)

### CPU 使用率（过去7天平均）

**Instance 1**: 0.08-0.10% CPU（几乎闲置）
**Instance 2**: 0.09-0.10% CPU（几乎闲置）

**结论**: 两台服务器基本没有负载，处于空闲状态。

### 存储配置

两台都使用:
- **8GB gp2** EBS 卷
- 成本: ~$0.64/月 每台

### 网络配置检查

- ❌ 无 Elastic IP 绑定
- ❌ 无 Load Balancer 连接
- ❌ 无 Route53 DNS 记录指向
- ✅ 使用临时公网 IP

**判断**: 这些不是生产环境的长期服务。

---

## 💰 成本分析

### 每台成本
- EC2 t3.micro: $0.0104/hour × 730 hours = **$7.59/月**
- EBS 8GB gp2: $0.10/GB/月 × 8GB = **$0.80/月**
- 数据传输: ~$0.10/月（估计）
- **每台总计: ~$8.49/月**

### 两台总成本
- **月度成本: ~$16.98**
- **年度成本: ~$203.76**

### 已运行成本（14天）
- **已花费: ~$7.92**

---

## 🎯 结论与建议

### 用途判断

这两台 EC2 很可能是：
1. **AWS 培训课程的实验环境**
   - Instance 2 标签明确写着 `Environment: Training`
   - 同时创建，相同配置
   - 运行简单的演示页面

2. **学习/测试项目**
   - Instance 1 标签 `application: corp_api` 可能是学习企业 API 开发
   - CPU 使用率极低，没有实际流量
   - 没有连接到任何生产服务

3. **与 Portfolio 项目无关**
   - 创建时间: 2025-12-21（最近）
   - Portfolio 网站使用 S3 + CloudFront，不需要 EC2 前端
   - 没有域名指向这些 IP
   - 不在 portfolio 的架构中

### 🚨 强烈建议: 删除

**理由**:
1. ✅ 与 Portfolio 项目**完全无关**
2. ✅ CPU 使用率 <0.1%，**没有实际用途**
3. ✅ 无生产服务依赖（无 DNS、无 LB、无 EIP）
4. ✅ 每月浪费 **~$17**，年度 **~$204**
5. ✅ 很可能是培训/测试遗留资源

**风险评估**: ⚠️ **删除风险极低**
- 没有域名指向，不会影响任何公开服务
- 没有 Elastic IP，重启后 IP 就会变
- 不在负载均衡器后面
- 不是 Portfolio 或 Chainy 的一部分

---

## 📋 删除步骤

### 方法 1: AWS Console（推荐，更安全）
1. 登录 AWS Console
2. EC2 → Instances
3. 选择实例 → Actions → Instance State → Terminate
4. 确认删除

### 方法 2: AWS CLI（快速）
```bash
# 先停止实例（可以先停止观察几天，确认无影响后再删除）
aws ec2 stop-instances --instance-ids i-02f2caee522bb3725 i-0262707311b4bddbd

# 等待停止
aws ec2 wait instance-stopped --instance-ids i-02f2caee522bb3725 i-0262707311b4bddbd

# 检查是否有问题（观察1-3天）
# 如果确认无影响，执行删除：
aws ec2 terminate-instances --instance-ids i-02f2caee522bb3725 i-0262707311b4bddbd
```

### 删除相关资源

删除 EC2 后，还应该清理：

```bash
# 1. 删除关联的 EBS 卷（如果没有自动删除）
aws ec2 describe-volumes --filters "Name=status,Values=available" \
  --query 'Volumes[*].[VolumeId,CreateTime]' --output table

# 2. 删除不需要的安全组
aws ec2 describe-security-groups --filters "Name=group-name,Values=web_server_sg" \
  --query 'SecurityGroups[*].[GroupId,GroupName]' --output table

# 如果确认不需要：
# aws ec2 delete-security-group --group-id sg-xxxxx

# 3. 删除不需要的 IAM roles（如果有）
aws iam list-roles --query 'Roles[?contains(RoleName, `api`) || contains(RoleName, `training`)]'
```

---

## ✅ 推荐行动计划

### 立即执行（安全措施）
```bash
# 1. 先停止实例，不是删除
aws ec2 stop-instances --instance-ids i-02f2caee522bb3725 i-0262707311b4bddbd
```
**成本节省**: 停止后只需支付 EBS 存储费用 (~$1.60/月)，节省 ~$15/月

### 观察期（1-3天）
- 检查是否有任何服务受影响
- 检查是否有告警或错误
- 确认没有人联系你说服务中断

### 确认删除（3天后）
```bash
# 如果确认无影响，彻底删除
aws ec2 terminate-instances --instance-ids i-02f2caee522bb3725 i-0262707311b4bddbd
```

---

## 🎓 学习价值

如果这些是培训项目：
- ✅ **已经达到学习目的**（运行了14天）
- ✅ 可以保存 AMI 供将来参考：
  ```bash
  aws ec2 create-image \
    --instance-id i-02f2caee522bb3725 \
    --name "training-live-visitor-feed-backup" \
    --description "Backup of training EC2 before deletion"
  ```
- ✅ 将来需要时可以快速重建（5分钟）

---

## 总结

| 问题 | 答案 |
|-----|------|
| 是否属于 Portfolio 项目？ | ❌ 否 |
| 是否属于 Chainy 项目？ | ❌ 否 |
| 是否有生产用途？ | ❌ 否（CPU <0.1%，无流量） |
| 是否可以删除？ | ✅ 是（风险极低） |
| 删除后节省成本？ | ✅ $16.98/月，$203.76/年 |
| **推荐行动** | **立即停止，3天后删除** |

---

## 执行命令（复制粘贴）

```bash
# 步骤 1: 立即停止（安全第一）
aws ec2 stop-instances --instance-ids i-02f2caee522bb3725 i-0262707311b4bddbd

# 步骤 2: 验证停止状态
aws ec2 describe-instances --instance-ids i-02f2caee522bb3725 i-0262707311b4bddbd \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name]' --output table

# 步骤 3: 观察 1-3 天，确认无影响

# 步骤 4: 彻底删除（3天后执行）
aws ec2 terminate-instances --instance-ids i-02f2caee522bb3725 i-0262707311b4bddbd

# 步骤 5: 清理 EBS 快照（可选）
aws ec2 describe-snapshots --owner-ids self \
  --filters "Name=description,Values=*training*" \
  --query 'Snapshots[*].[SnapshotId,Description,StartTime]' --output table
```
