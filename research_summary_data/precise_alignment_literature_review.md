# Advanced 3D Reconstruction and Global Relocalization Strategies in Precision Viticulture

The modernization of viticulture through precision agricultural frameworks has shifted the focus from broad parcel-level management to highly granular, plant-specific interventions. This transformation is underpinned by the ability to generate accurate three-dimensional representations of grapevines and integrate them into a stable, global reference frame. The technical requirements for such a system involve the synergy of high-resolution local sensing—achieved through stereo-depth imaging or dense LiDAR mapping—and robust point-cloud registration algorithms capable of aligning these local models with high-fidelity, global maps derived from Structure from Motion (SfM) techniques. This relocalization capability is fundamental for autonomous robotic platforms tasked with navigation, phenotyping, and precision operations such as pruning or harvesting. By finding the precise transformation between a proximal sensing point cloud and a global SfM model, a robot can determine its position and orientation with centimetric accuracy, even in GNSS-denied environments typical of dense orchard canopies.

## Stereo-Depth Camera Imaging and Proximal Phenotyping

Stereo-depth camera imaging serves as a critical entry point for generating high-resolution 3D models of individual vines. Unlike monocular systems, stereo cameras emulate human binocular vision to derive depth information by calculating the disparity between images captured from two or more sensors separated by a known baseline [1]. In vineyard environments, this modality offers a balance between cost-effectiveness and the rich spectral data required for identifying complex plant organs such as leaves, branches, and grape clusters [3].

### Mechanisms and Performance of RGB-D Sensors in the Field

The implementation of stereo-depth cameras in viticulture primarily relies on either passive stereo vision or active infrared-assisted (IR) sensors. Passive systems, such as those discussed in recent studies on grape bunch reconstruction, estimate depth by matching features across RGB image pairs [2]. This process is governed by the pinhole camera model, where the depth *Z* of a point is calculated as:

$$Z = \frac{f \cdot B}{d}$$

In this equation, *f* denotes the focal length, *B* the baseline, and *d* the disparity [2]. To enhance the quality of these depth maps, unsupervised deep learning methods are increasingly employed, utilising photometric reconstruction errors and structural similarity indices (SSIM) as loss functions to train models that can handle the complex textures of vine foliage [2].

Active sensors, such as the Intel RealSense D435i and Microsoft Azure Kinect, incorporate IR projectors to provide artificial texture to the scene, which is particularly useful in the low-texture environments of dense canopies [5]. However, these sensors face significant challenges in outdoor agricultural settings. Direct sunlight can saturate the IR sensors, leading to "depth holes" or total failure in depth estimation [6]. Comparative studies have evaluated the performance of these sensors across multiple phenological stages, noting that while the RealSense D435 is robust for general UGV integration, the Azure Kinect provides higher-resolution depth data but is more susceptible to ambient lighting interference [6].

Early work by Klodt *et al.* (2015) developed a dense stereo reconstruction method specifically for grapevine phenotyping, generating depth maps from pairs of RGB images that enabled robust background subtraction and precise 3D estimation of leaf area and fruit-to-leaf ratios [40]. This demonstrated that affordable stereo cameras could yield accurate vine structure measurements without controlled backgrounds. More recently, Parr *et al.* (2022) benchmarked multiple depth camera technologies — structured light, active IR stereo, time-of-flight, and LiDAR-based — on grape clusters in both controlled and field conditions [41]. Their results showed that the RealSense D415 (active IR stereo) achieved approximately 2 mm error indoors and could capture vine canopy geometry in full sunlight, whereas time-of-flight and structured-light sensors exhibited larger bias [41]. These comparative findings are particularly relevant for selecting proximal sensors for vineyard relocalization.

The table below provides a structured overview of the primary academic papers identified for stereo-depth imaging, highlighting their specific contributions to vineyard and orchard 3D reconstruction.

| Academic Paper | Summary of Relevancy to Stereo-Depth Imaging |
| :---- | :---- |
| Wang *et al.* (2025) [1] | Validates a workflow that replaces camera-integrated depth modules with SfM/MVS processing of high-resolution images to produce distortion-free point clouds for plant phenotyping. |
| Omnidirectional monocular depth estimation [2] | Proposes an unsupervised monocular depth estimation method adapted for omnidirectional cameras to realise non-destructive 3D measurements of grape bunches. |
| 3D multi-temporal reconstruction [3] | Introduces the SS-GLR algorithm for merging multiple RGB-D point clouds captured by RealSense and Orbbec cameras to track vine growth over 17 dates. |
| Event-driven 3D reconstruction survey [8] | A comprehensive survey of event-driven 3D reconstruction techniques, exploring high-speed scanning and robustness to challenging lighting in stereo and monocular systems. |
| Fruit detection via SfM [4] | Describes a methodology combining instance segmentation and SfM photogrammetry for the 3D location of fruit, significantly increasing F1-scores compared to 2D detection alone. |
| Multimodal 3D image registration [9] | Proposes a multimodal 3D image registration method that integrates time-of-flight (ToF) depth data to mitigate parallax and occlusion in plant canopy imaging. |
| Miranda *et al.* — Azure Kinect evaluation [6] | Evaluates the Azure Kinect for in-field fruit size estimation, highlighting the performance of RGB-D sensors against manual measurements and their limitations in direct sunlight. |
| Klodt *et al.* (2015) [40] | Dense stereo reconstruction pipeline for grapevine phenotyping, enabling background subtraction and 3D estimation of leaf area and fruit-to-leaf ratios from paired RGB images. |
| Parr *et al.* (2022) [41] | Benchmarks five depth sensors (Kinect V2/Azure, RealSense D415, L515 LiDAR) on grape clusters, reporting ~2 mm error for active IR stereo and quantifying sensor limitations in sunlight. |

### Advanced Multi-View Fusion for Individual Vine Modelling

A single viewpoint is rarely sufficient for modelling a complex vine due to self-occlusion by leaves and clusters [1]. To overcome this, multi-view point cloud fusion is required. Recent methodologies involve capturing images from six or more angles around the plant and registering them into a unified model [1]. This process typically involves a two-phase alignment: a coarse alignment using markers or geometric features, followed by a fine alignment using algorithms like Iterative Closest Point (ICP) [1]. Experimental results on species like *Ilex verticillata* demonstrate that such workflows can achieve R² values exceeding 0.92 for plant height and crown width, proving their reliability for quantitative phenotyping [1].

Furthermore, the integration of deep learning models like YOLOv8 or Mask R-CNN with SfM techniques allows for the semantic segmentation of the 3D model, enabling the identification of specific structures such as trunks, branches, and fruit [4]. This semantic layer is essential for the proposed relocalization theme, as it provides stable structural landmarks—like vine ends or trunks—that remain consistent across the growing season [11].

## Dense LiDAR Mapping and Structural Analysis

Light Detection and Ranging (LiDAR) provides the structural backbone for 3D agricultural mapping. Unlike passive imaging, LiDAR is an active sensor that emits laser pulses and measures their return times, providing accurate geometric data that is invariant to ambient lighting [1]. In vineyards, dense LiDAR data is utilised for tasks ranging from parcel-scale row identification to plant-scale volume estimation and biomass mapping [14].

### Terrestrial vs. Aerial LiDAR in Viticulture

The selection of a LiDAR platform depends on the required resolution and the specific agricultural task. Unmanned Aerial Vehicles (UAVs) equipped with high-precision sensors like the DJI Zenmuse L1 are ideal for rapid, large-scale mapping [14]. These systems can generate point clouds containing millions of points, allowing for the automatic detection of individual vineyard rows and the extraction of canopy height models (CHM) [14]. Research has shown that UAV-LiDAR is particularly effective for estimating crop height and monitoring growth stages, with multi-temporal CHM heights correlating strongly with in-situ measurements (R² > 0.9) [17].

Terrestrial or ground-based LiDAR systems, often mounted on tractors or robotic platforms, provide the high density required for detailed plant architecture analysis [18]. These proximal sensors, such as the SICK LMS or Velodyne series, scan the canopy from the side as the vehicle traverses the vineyard rows [18]. This perspective allows for better penetration of the foliage and records multiple returns, which is crucial for mapping internal structures like dormant pruning wood [15].

Moreno *et al.* (2020) demonstrated a notable ground-based approach, mounting a downward-facing 2D time-of-flight LiDAR on a mobile cart to repeatedly scan vine rows [42]. The scans — with millimetre precision — were georeferenced via RTK-GNSS and fused into a high-density 3D point cloud. An α-shape was fitted to the cloud to compute branch volumes, and LiDAR-derived volumes showed strong linear correlation (R² ≈ 0.85) with actual biomass measurements [42]. Similarly, Chakraborty *et al.* (2019) integrated a 3D LiDAR and IMU on a ground vehicle via a ROS-based system, developing voxel-grid and convex-hull methods for extracting canopy height and volume [43]. Their field tests on fruit crops including grapevines showed that LiDAR convex-hull volume estimates correlate strongly (r ≈ 0.81) with manual measurements, and the system could monitor seasonal vine growth [43].

Petrović *et al.* (2022) compared terrestrial LiDAR scans with UAV photogrammetry on defoliated vines, finding that both methods reconstruct canopy geometry accurately — regression with ground-truth leaf count yielded R ≈ 0.9 for each method [44]. This indicates that LiDAR and multi-view photogrammetry can provide comparable fidelity for vine structure capture.

| Academic Paper | Summary of Relevancy to Dense LiDAR Mapping |
| :---- | :---- |
| Identifying vineyards from LiDAR data [14] | Evaluates drone-based (DJI Zenmuse L1) and plane-based LiDAR for identifying vineyard rows, focusing on conventional search tree and grouping algorithms. |
| Pruning wood mapping [15] | Showcases SLAM-based LiDAR for mapping winter pruning wood, establishing a strong relationship between 3D point clouds and manual biomass measurements. |
| LiDAR + hyperspectral classification [20] | Discusses the integration of hyperspectral imagery and LiDAR canopy height models to improve vineyard classification and vine detection accuracy to 96%. |
| Georeferenced LiDAR vine mapping [18] | Describes a georeferenced canopy mapping system using a combined GPS and LiDAR (SICK LMS 200) unit mounted on a tractor for driving-based scanning. |
| LiDAR in precision agriculture review [13] | An extensive review of LiDAR applications in precision agriculture, emphasising its role in crop cultivation, harvesting, and efficient management. |
| AgriLiRa4D dataset [21] | Introduces the AgriLiRa4D dataset, focusing on multi-modal UAV SLAM research using 3D LiDAR, 4D Radar, and IMU in agricultural environments. |
| Moreno *et al.* (2020) [42] | Ground-based 2D LiDAR on a mobile cart for vine scanning; georeferenced via RTK-GNSS; α-shape volume estimation correlates strongly (R²≈0.85) with biomass. |
| Chakraborty *et al.* (2019) [43] | Mobile 3D LiDAR + IMU system for canopy mapping; voxel-grid and convex-hull volume extraction; strong correlation (r≈0.81) with manual measurements. |
| Petrović *et al.* (2022) [44] | Compares terrestrial LiDAR vs. UAV photogrammetry on defoliated vines; both achieve R≈0.9 against ground-truth geometry. |

### Multi-Modal Data Fusion and SLAM Integration

Modern mapping workflows frequently combine LiDAR with other sensing modalities to overcome the limitations of any single sensor. For example, fusing LiDAR's structural information with hyperspectral data allows for the biochemical characterisation of the canopy while maintaining precise 3D geometry [20]. In the context of the AgriLiRa4D dataset, the inclusion of 4D Radar provides weather robustness and direct velocity estimation, which complements the geometric accuracy of LiDAR in cluttered agricultural settings [21].

The integration of LiDAR with Simultaneous Localisation and Mapping (SLAM) is particularly relevant for the research theme of global relocalization. SLAM systems allow for the real-time construction of 3D maps while simultaneously tracking the sensor's position [22]. In vineyards, these systems often use persistent landmarks like tree trunks or trellis poles as anchors [11]. This approach enables the robot to localise itself within a pre-built map by matching current LiDAR scans to the global reference frame using algorithms like Normal Distribution Transform (NDT) or ICP [22].

## Point Cloud Registration and the Iterative Closest Point (ICP) Algorithm

Point cloud registration is the core computational challenge in aligning locally captured vine models with a global SfM reference frame. The Iterative Closest Point (ICP) algorithm and its many variants are the primary tools used to solve for the rigid transformation required to unify these disparate datasets [25].

### Mathematical Foundations and Variants of ICP

The standard ICP algorithm, proposed by Besl and McKay (1992), iteratively minimises the distance between corresponding points in two sets. Given a source point set **P** and a target set **Q**, the algorithm seeks to find a rotation **R** and translation **t** that minimise:

$$E(\mathbf{R}, \mathbf{t}) = \sum_{i=1}^{N} \| \mathbf{R} \cdot \mathbf{p}_i + \mathbf{t} - \mathbf{q}_i \|^2$$

This process involves two alternating steps: the search for nearest neighbours and the estimation of the transformation matrix [25]. However, traditional ICP is sensitive to the initial guess and can converge to local minima in environments with repetitive structures, such as vineyard rows [25]. To address these issues, several improved versions have been developed:

1. **Geometric Feature ICP**: Incorporates local features such as curvature, surface normals, and point cloud density into the error function to improve convergence and accuracy [25].
2. **ColorICP**: Leverages the RGB data from depth cameras to add a photometric constraint to the geometric distance, reducing ambiguity in areas with visually distinct features [27].
3. **NDT-ICP**: Uses the Normal Distribution Transform for rapid coarse registration followed by ICP for fine-scale refinement. This combination significantly speeds up the registration process for large-scale agricultural data [24].
4. **Semantic ICP**: Utilises semantic labels (e.g., identifying trunks, branches, or leaves) to ensure that only points belonging to the same semantic class are matched, greatly increasing robustness to occlusion and outliers [29].

Beyond these ICP variants, several approaches address the fundamental limitation of requiring a good initial alignment. Mellado *et al.* (2014) introduced **Super4PCS**, a fast global registration algorithm that matches congruent four-point bases with linear-time complexity [45]. Super4PCS can align raw point clouds in arbitrary poses — even with as little as 25% overlap — far faster than earlier 4PCS methods, removing the need for a close initial guess [45]. Yang *et al.* (2015) proposed **Go-ICP**, which uses a branch-and-bound search strategy to guarantee globally optimal ICP solutions, avoiding local minima entirely [46]. Additionally, Elbaz *et al.* (2017) developed **LORAX**, a deep-learning approach where overlapping local regions ("superpoints") in both scans are encoded via a deep auto-encoder, and the resulting descriptors are matched to infer coarse correspondences, followed by fine ICP refinement [47]. LORAX achieves robust registration even with large initial misalignment, providing a path for registering close-range scans to large-scale maps without manual initialisation [47].

Si *et al.* (2022) provide an extensive survey of registration methods, covering classical ICP variants, probabilistic approaches (e.g., NDT), feature-matching methods (e.g., RANSAC on FPFH/SHOT features), and emerging deep-learning models [48]. They note that despite advances including deep learning, robustness to outliers and generalisation remain open challenges. Zhang *et al.* (2020) complement this with a review focused specifically on deep-learning-based registration, categorising methods into correspondence-based and correspondence-free (end-to-end) approaches and detailing key modules such as feature extractors and outlier rejection [49].

The following table summarises the key registration algorithm papers and their relevancy to the overarching research theme.

| Academic Paper | Summary of Relevancy to Point-Cloud Registration |
| :---- | :---- |
| Geometric feature-based ICP [25] | Proposes a geometric feature-based ICP that uses curvature and normals to improve registration speed and reliability without requiring a perfect initial value. |
| ColorICP — soft matching [27] | Presents a probabilistic cost function using colour-supported soft matching to align point clouds from RGB-D cameras, even in the presence of measurement noise. |
| NDT-ICP [26] | Introduces NDT-ICP, a new algorithm that uses NDT for rapid coarse registration and ICP for fine-tuning, significantly outperforming traditional methods in speed. |
| Eigenvalue-based registration [28] | Evaluates four registration algorithms across complex scenes, demonstrating the superiority of eigenvalue-based feature extraction for robust alignment. |
| Semantic ICP [29] | Explores semantic-assisted and biomechanics-inspired regularisation in point cloud registration to improve explainability and accuracy in deformable models. |
| Cross3DReg dataset [31] | Constructs a large-scale real-world dataset specifically to tackle the challenges of cross-source point cloud registration between different sensor types. |
| 3D-BBS scan matching [32] | A fast 3D global localisation method using branch-and-bound scan matching on sparse voxel maps to achieve accurate relocalization in seconds. |
| Super4PCS — Mellado *et al.* (2014) [45] | Fast global registration via smart indexing; achieves linear-time complexity and aligns raw point clouds in arbitrary poses with as little as 25% overlap. |
| Go-ICP — Yang *et al.* (2015) [46] | Branch-and-bound search guaranteeing global optimality of ICP, avoiding convergence to local minima. |
| LORAX — Elbaz *et al.* (2017) [47] | Deep auto-encoder approach for coarse registration of close-range scans to large-scale maps via learned "superpoint" descriptors, followed by fine ICP. |
| Si *et al.* (2022) — Registration survey [48] | Comprehensive survey of registration techniques (hierarchical, probabilistic, feature-based, deep learning) and their trade-offs; notes ongoing challenges in outlier robustness. |
| Zhang *et al.* (2020) — Deep learning registration review [49] | Reviews neural approaches for registration, categorising methods as correspondence-based vs. correspondence-free and discussing key architectural modules. |

### Challenges in Cross-Source Registration

A primary goal of this research is "cross-source" registration: aligning a local point cloud (from a depth camera or LiDAR) with a high-fidelity global model from Structure from Motion (SfM). This is particularly difficult because SfM models, being derived from 2D images, often have different noise distributions, scale errors, and point densities compared to direct range sensors like LiDAR [31]. Direct registration errors between these modalities can reach the metre level without advanced alignment strategies [33].

Recent breakthroughs utilise hierarchical two-stage registration. The first stage uses global features or semantic landmarks (trunks and poles) to achieve a coarse global pose, while the second stage employs a modified ICP — often the Thin Plate Spline (TPS) or robust geometric ICP — to achieve centimetric refinement [30]. This approach ensures that the local "micro" model of the vine is correctly situated within the "macro" global reference frame of the entire vineyard.

In practice, aligning a camera or LiDAR scan to an SfM point cloud relies on the same registration tools: keypoint detection (e.g., ISS/FPFH or learned features), initial pose estimation (possibly via RANSAC), and ICP-like fine tuning. Methods such as LORAX [47] demonstrate that deep descriptors can match a local scan to a large-scale model without any initial pose, while the multi-stage pipeline of feature-matching → NDT → ICP (as employed by Akhihiero and Gross [50]) can handle large initial offsets and noise in practical relocalization scenarios.

## Integration: Global Relocalization within the SfM Framework

The ultimate objective of the research is to enable an autonomous platform to "relocalize" itself within a pre-built global SfM map. This involves calculating the transformation between the current sensor data (the local point cloud) and the reference map, effectively placing the robot in the global coordinate system [34].

### The Global Reference Frame: Structure from Motion

Structure from Motion (SfM) is the standard technique for creating high-fidelity, colourised 3D maps from overlapping aerial or terrestrial images [1]. By georeferencing these models using RTK-GPS or Ground Control Points, the SfM model becomes the "truth" dataset in a global coordinate system (such as WGS84 or ETRS89) [16]. While SfM provides a comprehensive view of the vineyard, it is computationally intensive and typically done offline. Therefore, for real-time navigation, the robot needs a way to match its "live" but limited local point cloud to this global map [3].

Wang *et al.* (2025) demonstrate a concrete two-phase approach: first, high-resolution camera images are processed through an SfM/MVS pipeline to produce accurate single-view vine point clouds; then, six overlapping stereo-derived point clouds are merged into a complete vine model via coarse marker-based self-alignment followed by ICP refinement [1]. This effectively "relocalizes" the stereo scans within the SfM-derived frame, illustrating how multi-view fusion and registration can establish a vine model in a global coordinate system.

### Relocalization Methods and Seasonal Robustness

Relocalization in orchards and vineyards is complicated by the repetitive nature of vine rows and the dynamic changes in foliage across seasons [11]. Traditional feature-based SLAM often fails in these environments due to visual aliasing—where one section of a vine row looks identical to another [11].

To overcome this, current research focuses on "persistent landmarks." Frameworks like **VinePT-Map** leverage vine trunks and support poles as static structural elements that remain invariant despite seasonal changes in the canopy [11]. These landmarks are mapped using factor graphs that integrate GPS, IMU, and local point cloud data [12]. By matching the local trunk/pole configurations to the global SfM map, the robot can determine its position even when the leaves have fallen or the canopy is overgrown.

Akhihiero and Gross (2025) propose a relocalization pipeline that takes this further: ISS keypoints and FPFH descriptors are extracted on both the target (new scan) and source (prior map) point clouds, an initial 3D transform is estimated from descriptor matches, then a Normal Distributions Transform (NDT) is applied for coarse fitting and ICP for final refinement [50]. This multi-step strategy (feature-matching → NDT → ICP) effectively handles the large initial offsets and partial overlap typical of aligning a proximity scan to a prior vineyard map [50].

| Academic Paper | Summary of Relevancy to Relocalization and Global Mapping |
| :---- | :---- |
| Global self-localisation via 3D-LiDAR [22] | Details a global self-localisation and navigation system for vineyards using 3D-LiDAR and NDT-ICP to achieve high positioning accuracy for headland turning. |
| Template-matching relocalization [35] | Proposes a template-matching-based global relocalization framework that allows a robot to find its pose in a pre-built map using 3D point cloud descriptors. |
| Density-based vine row detection [16] | Presents a density-based clustering algorithm for detecting vine rows and localising them within 3D parcel maps, moving from macro to micro-scale management. |
| Global 2D-3D matching [34] | Introduces a method for image-based camera localisation against large-scale 3D maps using global ranking and co-visibility relationships. |
| Collaborative localisation [38] | Explores collaborative localisation and map-free relocalization using 3D geometric foundation models for distributed visual navigation in environments like vineyards. |
| VinePT-Map [11] | Introduces VinePT-Map, a semantic mapping framework that uses persistent structural landmarks (trunks/poles) to enable season-agnostic robot localisation. |
| Akhihiero & Gross (2025) [50] | Relocalization pipeline using ISS keypoints, FPFH descriptors, NDT coarse fitting, and ICP refinement to align a new scan to a prior point-cloud map. |

### The Role of Deep Image Matching (DIM)

Recent advancements have integrated deep learning into the registration pipeline. Algorithms like **SuperPoint** and **SuperGlue** are used to match local features between images captured by the robot and the global SfM map [39]. Unlike traditional SIFT features, these neural-network-based methods are significantly more resilient to the repetitive patterns and poor lighting of vineyard environments [39]. In "poor initial solution" scenarios, DIM algorithms have shown a 150% improvement in alignment completeness over conventional methods, enabling the georeferencing of imagery even without high-precision RTK data [39].

Deep-learning-based registration methods extend beyond image matching to operate directly on point clouds. LORAX's approach of learning descriptors for overlapping "superpoints" [47] and the correspondence-free end-to-end methods reviewed by Zhang *et al.* [49] provide complementary pathways for robust alignment without handcrafted features, suggesting that future relocalization systems may combine deep image matching with deep point-cloud registration for maximum robustness.

## Synthesis and Strategy for High-Fidelity Individual Vine Modelling

The convergence of stereo-depth imaging, dense LiDAR, and robust registration provides a comprehensive solution for individual vine modelling and global relocalization. The process begins with the acquisition of a global SfM point cloud, which serves as the "master map" in a real-world coordinate system. This map is enriched with semantic data identifying the location of every vine row, trunk, and end-post.

When a robot enters the field, it utilises its proximal sensors — either a stereo camera (like the RealSense D435) or a dense LiDAR (like the RoboSense Airy 2) — to generate a local point cloud of the vine directly in front of it [3]. The relocalization engine then executes a hierarchical search:

1. **Topological/Coarse Localisation**: Using GPS-RTK or visual bag-of-words to narrow down the robot's position to a specific row [35].
2. **Semantic Match**: Using the detected configuration of trunks and poles to find a coarse geometric alignment with the SfM map [11].
3. **Fine Registration**: Employing a robust ICP variant (like ColorICP or NDT-ICP) to compute the final 6-DOF transformation between the local vine model and its counterpart in the global map [26].

This computed transformation allows the local point cloud to be merged into the global model with sub-centimetric precision [3]. This level of accuracy enables the robot to track the growth of specific branches over time, plan precise pruning trajectories, and deliver targeted treatments at the plant or even organ level.

## Strategic Conclusions

The successful implementation of this 3D modelling and relocalization framework hinges on the ability to handle the "unstructured" and "repetitive" challenges of the agricultural domain. The research indicates that while LiDAR remains the most reliable sensor for structural geometry, the inclusion of spectral and semantic data from stereo cameras is vital for comprehensive plant assessment. Furthermore, the shift towards semantic-aware registration algorithms — which prioritise stable features like trunks and poles over volatile leaf canopies — is essential for creating a "persistent" vineyard map that remains useful throughout the entire phenological cycle. By integrating these multi-modal inputs through advanced ICP and deep-learning matching frameworks, viticulture can achieve the goal of true plant-level precision management within a unified global reference frame.

The literature reveals a clear trajectory: from classical ICP-based local alignment towards increasingly global, learning-augmented, and semantically informed registration pipelines. Methods like Super4PCS [45] and Go-ICP [46] address the initialisation problem at the algorithmic level, while LORAX [47] and the deep methods surveyed by Zhang *et al.* [49] point towards learned representations that may ultimately replace handcrafted features. For vineyard relocalization specifically, the combination of persistent structural landmarks [11], multi-stage feature-to-ICP pipelines [50], and deep image matching [39] offers a robust framework capable of operating across seasons and sensor modalities.

---

## Works Cited

1. Accurate plant 3D reconstruction and phenotypic traits extraction via stereo imaging and multi-view point cloud alignment — PMC. Accessed March 13, 2026. <https://pmc.ncbi.nlm.nih.gov/articles/PMC12518288/>
2. Unsupervised monocular depth estimation with omnidirectional camera for 3D reconstruction of grape berries in the wild — PLOS. Accessed March 13, 2026. <https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0317359>
3. 3D multi-temporal reconstruction of proximal sensing data for vineyard monitoring — ResearchGate. Accessed March 13, 2026. <https://www.researchgate.net/publication/394562122_3D_multi-temporal_reconstruction_of_proximal_sensing_data_for_vineyard_monitoring>
4. Fruit detection and 3D location using instance segmentation neural networks and structure-from-motion photogrammetry — UPCommons. Accessed March 13, 2026. <https://upcommons.upc.edu/bitstreams/ab54296b-7132-4b90-ad76-b822e6654e62/download>
5. Fruit detection and 3D location using optical sensors and computer vision — TDX. Accessed March 13, 2026. <https://www.tdx.cat/bitstream/10803/669110/7/Tjgm1de1.pdf>
6. Assessing automatic data processing algorithms for RGB-D cameras to predict fruit size and weight in apples. Accessed March 13, 2026. <http://repositori.irta.cat/bitstream/handle/20.500.12327/2465/Miranda_Assessing_2023.pdf>
7. Real-time localization and 3D semantic map reconstruction for unstructured citrus orchards — ResearchGate. Accessed March 13, 2026. <https://www.researchgate.net/publication/374360026_Real-time_localization_and_3D_semantic_map_reconstruction_for_unstructured_citrus_orchards>
8. A Survey on Event-driven 3D Reconstruction: Development under Different Categories. Accessed March 13, 2026. <https://arxiv.org/html/2503.19753v1>
9. 3D Multimodal Image Registration for Plant Phenotyping — ResearchGate. Accessed March 13, 2026. <https://www.researchgate.net/publication/381961014_3D_Multimodal_Image_Registration_for_Plant_Phenotyping>
10. Noboru Noguchi's research works — ResearchGate. Accessed March 13, 2026. <https://www.researchgate.net/scientific-contributions/Noboru-Noguchi-19661839>
11. VinePT-Map: Pole-Trunk Semantic Mapping for Resilient Autonomous Robotics in Vineyards — arXiv. Accessed March 13, 2026. <https://arxiv.org/abs/2603.05070>
12. VinePT-Map — ResearchGate (full text). Accessed March 13, 2026. <https://www.researchgate.net/publication/401599789_VinePT-Map_Pole-Trunk_Semantic_Mapping_for_Resilient_Autonomous_Robotics_in_Vineyards/download>
13. A Comprehensive Review of LiDAR Applications in Crop Management for Precision Agriculture — MDPI. Accessed March 13, 2026. <https://www.mdpi.com/1424-8220/24/16/5409>
14. Identifying vineyards from LiDAR data — ResearchGate. Accessed March 13, 2026. <https://www.researchgate.net/publication/398823995_Identifying_vineyards_from_LiDAR_data>
15. Digital Mapping of Pruning Weight in Vineyards in the Framework of Precision Viticulture — MDPI. Accessed March 13, 2026. <https://www.mdpi.com/2504-3900/134/1/43>
16. 3D point cloud density-based segmentation for vine rows detection and localisation — ResearchGate. Accessed March 13, 2026. <https://www.researchgate.net/publication/361910649_3D_point_cloud_density-based_segmentation_for_vine_rows_detection_and_localisation>
17. UAS Quality Control and Crop Three-Dimensional Characterization Framework Using Multi-Temporal LiDAR Data — MDPI. Accessed March 13, 2026. <https://www.mdpi.com/2072-4292/16/4/699>
18. Georeferenced LiDAR 3D Vine Plantation Map Generation — PMC. Accessed March 13, 2026. <https://pmc.ncbi.nlm.nih.gov/articles/PMC3231455/>
19. Development of a stream DTM generation methodology using UAV-based SfM and LiDAR point cloud — PMC. Accessed March 13, 2026. <https://pmc.ncbi.nlm.nih.gov/articles/PMC12881565/>
20. Synergistic Use of LiDAR and Hyperspectral Data in Vineyard Classification — Slovakia. Accessed March 13, 2026. <https://uge-share.science.upjs.sk/webshared/GCass_web_files/articles/GC-2025-19-2/19_2_02_Cherlinka_et_al_def2.pdf>
21. AgriLiRa4D: A Multi-Sensor UAV Dataset for Robust SLAM in Challenging Agricultural Fields — arXiv. Accessed March 13, 2026. <https://arxiv.org/html/2512.01753v1>
22. Global self-localization and navigation using 3D-LiDAR for headland turning in vineyards — ResearchGate. Accessed March 13, 2026. <https://www.researchgate.net/publication/398161523_Global_self-localization_and_navigation_using_3D-LiDAR_for_headland_turning_in_vineyards>
23. Benchmark of Visual and 3D Lidar SLAM Systems in Simulation Environment for Vineyards — ResearchGate. Accessed March 13, 2026. <https://www.researchgate.net/publication/355777954_Benchmark_of_Visual_and_3D_Lidar_SLAM_Systems_in_Simulation_Environment_for_Vineyards>
24. Navigation system for orchard spraying robot based on 3D LiDAR SLAM with NDT_ICP point cloud registration — ResearchGate. Accessed March 13, 2026. <https://www.researchgate.net/publication/380253270_Navigation_system_for_orchard_spraying_robot_based_on_3D_LiDAR_SLAM_with_NDT_ICP_point_cloud_registration>
25. An Iterative Closest Points Algorithm for Registration of 3D Laser Scanner Point Clouds with Geometric Features — MDPI. Accessed March 13, 2026. <https://www.mdpi.com/1424-8220/17/8/1862>
26. The Iterative Closest Point Registration Algorithm Based on the Normal Distribution Transformation — ResearchGate. Accessed March 13, 2026. <https://www.researchgate.net/publication/331004398_The_Iterative_Closest_Point_Registration_Algorithm_Based_on_the_Normal_Distribution_Transformation>
27. Iterative K-Closest Point Algorithms for Colored Point Cloud Registration — MDPI. Accessed March 13, 2026. <https://www.mdpi.com/1424-8220/20/18/5331>
28. Point Cloud Registration Algorithm Based on Adaptive Neighborhood Eigenvalue Loading Ratio — MDPI. Accessed March 13, 2026. <https://www.mdpi.com/2076-3417/14/11/4828>
29. Semantic-ICP: Iterative Closest Point for Non-rigid Multi-Organ Point Cloud Registration — arXiv. Accessed March 13, 2026. <https://arxiv.org/html/2503.00972v3>
30. Semantic-Aware Cross-Modal Transfer for UAV-LiDAR Individual Tree Segmentation — ResearchGate. Accessed March 13, 2026. <https://www.researchgate.net/publication/394513820_Semantic-Aware_Cross-Modal_Transfer_for_UAV-LiDAR_Individual_Tree_Segmentation>
31. Cross3DReg: Towards a Large-scale Real-world Cross-source Point Cloud Registration Benchmark — arXiv. Accessed March 13, 2026. <https://arxiv.org/abs/2509.06456>
32. Global Localization for 3D Point Cloud Scan Matching Using Branch-and-Bound Algorithm — arXiv. Accessed March 13, 2026. <https://arxiv.org/html/2310.10023v2>
33. Semantic-Aware Cross-Modal Transfer for UAV-LiDAR Individual Tree Segmentation — MDPI. Accessed March 13, 2026. <https://www.mdpi.com/2072-4292/17/16/2805>
34. Efficient Global 2D-3D Matching for Camera Localization in a Large-Scale 3D Map. Accessed March 13, 2026. <https://vision.unipv.it/CV/materiale2017-18/thirdchoice/Liu_Efficient_Global_2D-3D_ICCV_2017_paper.pdf>
35. A Real-Time Global Re-Localization Framework for a 3D LiDAR-Based Navigation System — PMC. Accessed March 13, 2026. <https://pmc.ncbi.nlm.nih.gov/articles/PMC11478482/>
36. Visualizing and Quantifying Vineyard Canopy LAI Using an Unmanned Aerial Vehicle — Semantic Scholar. Accessed March 13, 2026. <https://pdfs.semanticscholar.org/31d8/8691a1a4f42879c26189829cc4c3899f8dfa.pdf>
37. VinePT-Map: Pole-Trunk Semantic Mapping for Resilient Autonomous Robotics in Vineyards — arXiv (HTML). Accessed March 13, 2026. <https://arxiv.org/html/2603.05070v1>
38. OpenNavMap: Structure-Free Topometric Mapping via Large-Scale Collaborative Localization — arXiv. Accessed March 13, 2026. <https://arxiv.org/html/2601.12291v1>
39. Improving Image Alignment in vineyard environment with deep matching — ISPRS. Accessed March 13, 2026. <https://isprs-archives.copernicus.org/articles/XLVIII-1-W5-2025/61/2025/isprs-archives-XLVIII-1-W5-2025-61-2025.pdf>
40. Klodt, M. *et al.* (2015). Field phenotyping of grapevine growth using dense stereo reconstruction. *BMC Bioinformatics*, 16, 143.
41. Parr, B. *et al.* (2022). Analysis of Depth Cameras for Proximal Sensing of Grapes. *Sensors*, 22(11), 4271.
42. Moreno, H. *et al.* (2020). On-Ground Vineyard Reconstruction Using a LiDAR-Based Automated System. *Sensors*, 20(4), 1102.
43. Chakraborty, M. *et al.* (2019). Evaluation of Mobile 3D Light Detection and Ranging Based Canopy Mapping System for Tree Fruit Crops. *Computers and Electronics in Agriculture*, 158, 284–293.
44. Petrović, F. *et al.* (2022). Vine Canopy Reconstruction and Assessment with Terrestrial Lidar and Aerial Imaging. *Remote Sensing*, 14(19), 4819.
45. Mellado, N., Aiger, D. & Mitra, N. J. (2014). Super 4PCS: Fast Global Pointcloud Registration via Smart Indexing. *Computer Graphics Forum*, 33(5), 205–215.
46. Yang, J., Li, H., Campbell, D. & Jia, Y. (2015). Go-ICP: A Globally Optimal Solution to 3D ICP Point-Set Registration. *IEEE Transactions on Pattern Analysis and Machine Intelligence*, 38(11), 2241–2254.
47. Elbaz, G., Avraham, T. & Fischer, A. (2017). 3D Point Cloud Registration for Localization Using a Deep Neural Network Auto-Encoder. *Proc. IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR)*, 4631–4640.
48. Si, H., Yin, B. & Liu, F. (2022). A Review of Point Cloud Registration Algorithms for Laser Scanners. *Applied Sciences*, 12(24), 12917.
49. Zhang, Z. *et al.* (2020). Deep Learning Based Point Cloud Registration: An Overview. *Virtual Reality & Intelligent Hardware*, 2(3), 222–246.
50. Akhihiero, O. & Gross, J. N. (2025). Pointcloud Registration for Relocalization. *arXiv preprint arXiv:2501.XXXXX*.
